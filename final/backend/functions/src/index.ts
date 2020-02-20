import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

console.log(`Starting up MakeItSo Cloud Functions`)

admin.initializeApp()
const db = admin.firestore()

export const migrateTasks = functions.https.onCall(async (data, context) => {
  console.log(`Received data" ${data}.`)

  const previousUserId = data.previousUserId
  console.log(`Migrating tasks from old userID [${previousUserId}] to new userID [${context.auth?.uid}].`)

  const batch = db.batch()
  const tasksToMigrate = await db.collection('tasks').where('userId', '==', previousUserId).get()
  if (tasksToMigrate.empty) {
    console.log(`Previous user [${previousUserId}] didn\'t have any documents, nothing to do.`)
  }
  else {
    console.log(`Migrating ${tasksToMigrate.size} tasks from userID [${previousUserId}] to new userId [${context.auth?.uid}]`)
    tasksToMigrate.forEach(snapshot => {
      batch.update(snapshot.ref, { 'userId': context.auth?.uid })
    })
  
    await batch.commit()

    try {
      await admin.auth().deleteUser(previousUserId)
    }
    catch(error) {
      console.log(`Error when trying to delete user ${previousUserId}: ${error}`)
    }
  }

  return {
    'updatedDocCount': tasksToMigrate.size,
    'previousUserId': previousUserId,
    'newUserId': context.auth?.uid
  }
})