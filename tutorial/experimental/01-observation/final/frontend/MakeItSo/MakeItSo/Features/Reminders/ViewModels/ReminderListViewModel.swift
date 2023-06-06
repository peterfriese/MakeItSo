//
// ReminderListViewModel.swift
// MakeItSo
//
// Created by Peter Friese on 15.05.23.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import Factory
import Combine
import Observation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@Observable
class RemindersListViewModel {
  // MARK: - Dependencies
  @ObservationIgnored
  @Injected(\.firestore) var firestore

  @ObservationIgnored
  @Injected(\.authenticationService) var authenticationService

  var reminders = [Reminder]()

  var errorMessage: String? = nil

  var user: User? = nil

  private var listenerRegistration: ListenerRegistration? = nil

  init() {
    print(authenticationService.user)
    subscribe()
  }

  deinit {
    unsubscribe()
  }

  func subscribe(user: User? = nil) {
    if listenerRegistration == nil {
      if let localUser = user ?? authenticationService.user {
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

  func addReminder(_ reminder: Reminder) {
    var userReminder = reminder
    userReminder.userId = user?.uid

    do {
      try firestore
        .collection(Reminder.collectionName)
        .addDocument(from: userReminder)
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func updateReminder(_ reminder: Reminder) {
    guard let documentId = reminder.id else {
      fatalError("Reminder \(reminder.title) has no document ID.")
    }

    do {
      try firestore
        .collection(Reminder.collectionName)
        .document(documentId)
        .setData(from: reminder, merge: true)
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }

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

  func setCompleted(_ reminder: Reminder, isCompleted: Bool) {
    var editedReminder = reminder
    editedReminder.isCompleted = isCompleted
    updateReminder(editedReminder)
  }

}
