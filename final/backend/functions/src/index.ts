import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

console.log(`Starting up MakeItSo Cloud Functions`)

admin.initializeApp()
const db = admin.firestore()

export const migrateTasks = functions.https.onCall(async (data, context) => {
  console.log('Received data: %j', data)

  const idToken = data.idToken

  try {
    console.log(`Verifying ID token ${idToken}`)
    const decodedToken = await admin.auth().verifyIdToken(idToken)
    if (context.auth) {
      return performMigration(decodedToken, context.auth?.token)
    }
    else {
      return {
        error: "Context was empty"
      }
    }      
  } 
  catch (error) {
    console.log(`Unable to verify ID token ${idToken}. Error: ${error}`)
    return { error }
  }
})

async function performMigration(previousUserToken: admin.auth.DecodedIdToken, currentUserToken: admin.auth.DecodedIdToken) {
  const previousUserId = previousUserToken.uid
  const currentUserId = currentUserToken.uid

  console.log(`Previous user ID: ${previousUserId}`)
  console.log(`New user ID: ${currentUserId}`)

  console.log(`Migrating tasks from old userID [${previousUserId}] to new userID [${currentUserId}].`)

  const batch = db.batch()
  const tasksToMigrate = await db.collection('tasks').where('userId', '==', previousUserId).get()
  if (tasksToMigrate.empty) {
    console.log(`Previous user [${previousUserId}] didn\'t have any documents, nothing to do.`)
  }
  else {
    console.log(`Migrating ${tasksToMigrate.size} tasks from userID [${previousUserId}] to new userId [${currentUserId}]`)
    tasksToMigrate.forEach(snapshot => {
      batch.update(snapshot.ref, { 'userId': currentUserId })
    })
  
    await batch.commit()
  }

  return {
    'updatedDocCount': tasksToMigrate.size,
    'previousUserId': previousUserId,
    'newUserId': currentUserId
  }
}