import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

let db: FirebaseFirestore.Firestore
const logger = functions.logger
const gracePeriod = 5 * 60 * 1000
let initialized = false

function initialize() {
  if (initialized === true) return
  initialized = true
  
  logger.log(`Starting up MakeItSo Cloud Functions`)
  admin.initializeApp()
  db = admin.firestore()  
}


async function performMigration(
  anonymousIdToken: admin.auth.DecodedIdToken, 
  permanentAccountIdToken: admin.auth.DecodedIdToken
  ) {
  const anonymousUserId = anonymousIdToken.uid
  const permamentUserId = permanentAccountIdToken.uid

  logger.log(`Migrating tasks from previous userID [${anonymousUserId}] to new userID [${permamentUserId}].`)

  return db.runTransaction( async transaction => {
    const tasksToMigrateQuery = db.collection('tasks').where('userId', '==', anonymousUserId)
    const tasksToMigrate = await transaction.get(tasksToMigrateQuery)

    if (tasksToMigrate.empty) {
      logger.log(`Previous user [${anonymousUserId}] didn\'t have any documents, nothing to do.`)
    }
    else {
      logger.log(`Migrating ${tasksToMigrate.size} tasks from userID [${anonymousUserId}] to new userId [${permamentUserId}]`)
      tasksToMigrate.forEach(snapshot => {
        transaction.update(snapshot.ref, { 'userId': permamentUserId })
      })
    }
    return {
      'updatedDocCount': tasksToMigrate.size,
      'anonymousUserId': anonymousUserId,
      'permamentUserId': permamentUserId
    }
  })
}

function isAnonymous(idToken: admin.auth.DecodedIdToken) {
  return idToken.firebase.sign_in_provider === "anonymous"
}

async function verifyAnonymousUserIdToken(anonymousIdToken: string) {
  logger.log(`Verifying anonymous ID token ${anonymousIdToken}`)
  const verifiedAnonymousIdToken = await admin.auth().verifyIdToken(anonymousIdToken)
  
  
  if (!isAnonymous(verifiedAnonymousIdToken)) {
    throw new functions.https.HttpsError('invalid-argument', 'ID token must be anonymous', verifiedAnonymousIdToken)
  }
  return verifiedAnonymousIdToken
}

async function verifyPermanentUserIdToken(permanentAccountIdToken: admin.auth.DecodedIdToken) {
  logger.log(`Verifying permanent ID token ${permanentAccountIdToken}`)

  if (isAnonymous(permanentAccountIdToken)) {
    throw new functions.https.HttpsError('invalid-argument', 'ID token must be non-anonymous', permanentAccountIdToken)
  }

  const authTime = permanentAccountIdToken.auth_time * 1000
  const timeSinceSignIn = Date.now() - authTime

  if (timeSinceSignIn > gracePeriod) {
    throw new functions.https.HttpsError(
      'invalid-argument', 
      `This operation requires a recent sign-in.`,
      permanentAccountIdToken)
  }
  
  return permanentAccountIdToken
}

export const migrateTasks = functions.https.onCall(async (data, context) => {
  initialize()
  
  if (!context.auth) {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called while authenticated.')
  }
  else {
    logger.log('Received data: %j', data)
    
    const verifiedAnonymousIdToken = await verifyAnonymousUserIdToken(data.idToken)
    const permanentAccountIdToken = await verifyPermanentUserIdToken(context.auth?.token)
    return performMigration(verifiedAnonymousIdToken, permanentAccountIdToken)        
  }
})
