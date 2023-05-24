import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class RemindersRepository: ObservableObject {

  @Published
  var reminders = [Reminder]()

  func subscribe() {
    let query = Firestore.firestore().collection("reminders")

    query
      .addSnapshotListener { [weak self] (querySnapshot, error) in
      }
  }

  func addReminder(_ reminder: Reminder) throws {
    try Firestore
      .firestore()
      .collection("reminders")
      .addDocument(from: reminder)
  }

}
