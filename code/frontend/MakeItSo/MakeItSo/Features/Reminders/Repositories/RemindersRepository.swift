//
// RemindersRepository.swift
// MakeItSo
//
// Created by Peter Friese on 19.05.23.
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
import os
import Factory
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine

public class RemindersRepository: ObservableObject {
  // MARK: - Dependencies
  @Injected(\.firestore) var firestore
  @Injected(\.authenticationService) var authenticationService
  let logger = Container.shared.logger("persistence")

  // MARK: - Publishers
  @Published
  var reminders = [Reminder]()

  @Published
  var user: User? = nil

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

  // MARK: - Private attributes
  private var listenerRegistration: ListenerRegistration?

  deinit {
    unsubscribe()
  }

  private func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }

  private func subscribe(user: User? = nil) {
    if listenerRegistration == nil {
      if let localUser = user ?? self.user {
        let query = firestore.collection("reminders")
          .whereField("userId", isEqualTo: localUser.uid)
          .order(by: "createdAt", descending: true)

        listenerRegistration = query
          .addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              self?.logger.debug("No documents")
              return
            }

            // see https://stackoverflow.com/a/50434127/281221
            // and https://medium.com/firebase-developers/the-secrets-of-firestore-fieldvalue-servertimestamp-revealed-29dd7a38a82b
            if let hasPenddingWrites = querySnapshot?.metadata.hasPendingWrites, hasPenddingWrites == true {
              self?.logger.debug("Has pending writes")
            }
            self?.logger.debug("Mapping \(documents.count) documents")
            self?.reminders = documents.compactMap { queryDocumentSnapshot in
              do {
                return try queryDocumentSnapshot.data(as: Reminder.self)
              }
              catch {
                self?.logger.debug("Error while trying to map document \(queryDocumentSnapshot.documentID): \(error.localizedDescription)")
                return nil
              }
            }
          }
      }
    }
  }

  func addReminder(_ reminder: Reminder) {
    do {
      var userReminder = reminder
      userReminder.userId = user?.uid
      logger.debug("Adding reminder '\(userReminder.title)' for user \(userReminder.userId ?? "")")
      try firestore.collection("reminders").addDocument(from: userReminder)
    }
    catch {
      logger.error("Error: \(error.localizedDescription)")
    }
  }

  func updateReminder(_ reminder: Reminder) {
    if let documentId = reminder.id {
      do {
        try firestore.collection("reminders").document(documentId).setData(from: reminder)
      }
      catch {
        self.logger.debug("Unable to update document \(documentId): \(error.localizedDescription)")
      }
    }
  }

  func removeReminder(_ reminder: Reminder) {
    if let reminderID = reminder.id {
      firestore.collection("reminders").document(reminderID).delete() { error in
        if let error = error {
          self.logger.debug("Unable to remove document \(error.localizedDescription)")
        }
      }
    }
  }

}
