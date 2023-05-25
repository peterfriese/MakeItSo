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
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }

        print("Mapping \(documents.count) documents")
        documents.compactMap { queryDocumentSnapshot in
          return queryDocumentSnapshot.data(as: Reminder.self)
        }
      }
  }

  func addReminder(_ reminder: Reminder) throws {
    try Firestore
      .firestore()
      .collection("reminders")
      .addDocument(from: reminder)
  }

}