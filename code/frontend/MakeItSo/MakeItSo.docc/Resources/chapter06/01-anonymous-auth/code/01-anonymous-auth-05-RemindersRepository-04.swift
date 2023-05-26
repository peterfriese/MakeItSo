import Foundation
import Combine
import Factory
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

public class RemindersRepository: ObservableObject {
  // MARK: - Dependencies
  @Injected(\.firestore) var firestore
  @Injected(\.authenticationService) var authenticationService

  @Published
  var reminders = [Reminder]()

  @Published
  var user: User? = nil

  private var listenerRegistration: ListenerRegistration?
  private var cancelables = Set<AnyCancellable>()

  init() {
    authenticationService.$user
      .assign(to: &$user)

    $user.sink { user in
      self.unsubscribe()
      self.subscribe(user: user)
    }
    .store(in: &cancelables)

  }

  deinit {
    unsubscribe()
  }

  func subscribe(user: User? = nil) {
    if listenerRegistration == nil {
      if let localUser = user ?? self.user {
        let query = firestore.collection(Reminder.collectionName)
          .whereField("userId", isEqualTo: localUser.uid)

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
  }

  private func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }

  func addReminder(_ reminder: Reminder) throws {
    var mutableReminder = reminder
    mutableReminder.userId = user?.uid

    try firestore
      .collection(Reminder.collectionName)
      .addDocument(from: mutableReminder)
  }

  func updateReminder(_ reminder: Reminder) throws {
    guard let documentId = reminder.id else {
      fatalError("Reminder \(reminder.title) has no document ID.")
    }
    try firestore
      .collection(Reminder.collectionName)
      .document(documentId)
      .setData(from: reminder, merge: true)
  }

  func removeReminder(_ reminder: Reminder) {
    guard let documentId = reminder.id else {
      fatalError("Reminder \(reminder.title) has no document ID.")
    }
    firestore
      .collection(Reminder.collectionName)
      .document(documentId)
      .delete()
  }

}
