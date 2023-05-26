//
// RemindersRepository.swift
// MakeItSo
//
// Created by Peter Friese on 23.05.23.
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
import Combine
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
      let query = firestore.collection(Reminder.collectionName)

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
    try firestore
      .collection(Reminder.collectionName)
      .addDocument(from: reminder)
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
