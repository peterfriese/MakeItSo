import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

let db: FirebaseFirestore.Firestore
const logger = functions.logger
let initialized = false

function initialize() {
  if (initialized === true) return
  initialized = true
  
  logger.log(`Starting up MakeItSo Cloud Functions`)
  admin.initializeApp()
  db = admin.firestore()  
}


async function performMigration(
  previousUserToken: admin.auth.DecodedIdToken, 
  currentUserToken: admin.auth.DecodedIdToken
  ) {
  const previousUserId = previousUserToken.uid
  const currentUserId = currentUserToken.uid

  logger.log(`Migrating tasks from previous userID [${previousUserId}] to new userID [${currentUserId}].`)

  return db.runTransaction( async transaction => {
    const tasksToMigrateQuery = db.collection('tasks').where('userId', '==', previousUserId)
    const tasksToMigrate = await transaction.get(tasksToMigrateQuery)

    if (tasksToMigrate.empty) {
      logger.log(`Previous user [${previousUserId}] didn\'t have any documents, nothing to do.`)
    }
    else {
      logger.log(`Migrating ${tasksToMigrate.size} tasks from userID [${previousUserId}] to new userId [${currentUserId}]`)
      tasksToMigrate.forEach(snapshot => {
        transaction.update(snapshot.ref, { 'userId': currentUserId })
      })
    }
    return {
      'updatedDocCount': tasksToMigrate.size,
      'previousUserId': previousUserId,
      'newUserId': currentUserId
    }
  })
}

export const migrateTasks = functions.https.onCall(async (data, context) => {
  initialize()
  
  if (context.auth) {
    logger.log('Received data: %j', data)

    const idToken = data.idToken
    logger.log(`Verifying ID token ${idToken}`)
    try {
      const decodedToken = await admin.auth().verifyIdToken(idToken)
      return performMigration(decodedToken, context.auth?.token)        
    } 
    catch (error) {
      logger.error(`Error when trying to verify ID token. Error: ${error}`)  
      return { error }
    }
  }
  else {
    logger.error(`Unauthorized call.`)
    return { }
  }
})