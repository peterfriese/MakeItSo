import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class RemindersRepository: ObservableObject {

  @Published
  var reminders = [Reminder]()

  // (code ommitted for brevity)

  func addReminder(_ reminder: Reminder) throws {
    try Firestore
      .firestore()
      .collection(Reminder.collectionName)
      .addDocument(from: reminder)
  }

  func updateReminder(_ reminder: Reminder) throws {
  }

}
