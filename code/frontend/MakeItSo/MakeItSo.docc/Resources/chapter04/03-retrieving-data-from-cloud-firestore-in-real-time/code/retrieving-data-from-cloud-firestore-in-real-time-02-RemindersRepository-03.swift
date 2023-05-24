import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class RemindersRepository: ObservableObject {

  @Published
  var reminders = [Reminder]()

  private var listenerRegistration: ListenerRegistration?

  func subscribe() {
    if listenerRegistration == nil {
      let query = Firestore.firestore().collection("reminders")

      listenerRegistration = query
        .addSnapshotListener { [weak self] (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            print("No documents")
            return
          }

          print("Mapping \(documents.count) documents")
          self?.reminders = documents.compactMap { queryDocumentSnapshot in
            do {
              return try queryDocumentSnapshot.data(as: Reminder.self)
            }
            catch {
              print("Error while trying to map document \(queryDocumentSnapshot.documentID): \(error.localizedDescription)")
              return nil
            }
          }
        }
    }
  }

  private func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }

  func addReminder(_ reminder: Reminder) throws {
    try Firestore
      .firestore()
      .collection("reminders")
      .addDocument(from: reminder)
  }

}
