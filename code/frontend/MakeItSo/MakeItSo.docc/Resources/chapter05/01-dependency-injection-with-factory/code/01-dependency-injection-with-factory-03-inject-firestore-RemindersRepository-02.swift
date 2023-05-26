import Foundation
import Factory
import FirebaseFirestore
import FirebaseFirestoreSwift

public class RemindersRepository: ObservableObject {
  // MARK: - Dependencies
  @Injected(\.firestore) var firestore

  @Published
  var reminders = [Reminder]()

  private var listenerRegistration: ListenerRegistration?

  init() {
    subscribe()
  }

  deinit {
    unsubscribe()
  }

  func subscribe() {
    if listenerRegistration == nil {
      let query = Firestore.firestore().collection(Reminder.collectionName)

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
      .collection(Reminder.collectionName)
      .addDocument(from: reminder)
  }

  func updateReminder(_ reminder: Reminder) throws {
    guard let documentId = reminder.id else {
      fatalError("Reminder \(reminder.title) has no document ID.")
    }
    try Firestore
      .firestore()
      .collection(Reminder.collectionName)
      .document(documentId)
      .setData(from: reminder, merge: true)
  }

  func removeReminder(_ reminder: Reminder) {
    guard let documentId = reminder.id else {
      fatalError("Reminder \(reminder.title) has no document ID.")
    }
    Firestore
      .firestore()
      .collection(Reminder.collectionName)
      .document(documentId)
      .delete()
  }

}
