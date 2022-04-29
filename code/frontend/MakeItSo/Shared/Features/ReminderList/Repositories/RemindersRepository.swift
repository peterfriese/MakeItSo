//
//	RemindersRepository.swift
//  MakeItSo
//
//  Created by Peter Friese on 16.12.21.
//  Copyright © 2021 Google LLC. All rights reserved.
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
import Firebase
import FirebaseFirestoreSwift
import Resolver
import os

class RemindersRepository: ObservableObject {
  // MARK: - Dependencies
  @Injected var db: Firestore
  @Injected var authenticationService: AuthenticationService
  
  // MARK: - Publishers
  @Published public var reminders = [Reminder]()
  
  // MARK: - Private attributes
  private var userId: String = "unknown"
  private var listenerRegistration: ListenerRegistration?
  private var cancellables = Set<AnyCancellable>()
  
  let logger = Logger(subsystem: "dev.peterfriese.MakeItSo", category: "persistence")
  
  init() {
    // observe user ID
    authenticationService.$user
      .compactMap { user in
        user?.uid
      }
      .assign(to: \.userId, on: self)
      .store(in: &cancellables)
    
    authenticationService.$user
      .receive(on: DispatchQueue.main)
      .sink { [weak self] user in
        if self?.listenerRegistration != nil {
          self?.unsubscribe()
          self?.subscribe()
        }
      }
      .store(in: &cancellables)
  }
  
  deinit {
    unsubscribe()
  }
  
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
    if listenerRegistration != nil {
      unsubscribe()
    }
    let query = db.collection("reminders")
      .whereField("userId", isEqualTo: userId)
    
    listenerRegistration = query
      .addSnapshotListener { [weak self] (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          self?.logger.debug("No documents in 'reminders' collection")
          return
        }
        
        self?.reminders = documents.compactMap { queryDocumentSnapshot in
          let result = Result { try queryDocumentSnapshot.data(as: Reminder.self) }
          
          switch result {
          case .success(let reminder):
            // A `Reminder` value was successfully initialized from the DocumentSnapshot.
            return reminder
          case .failure(let error):
            // A `Reminder` value could not be initialized from the DocumentSnapshot.
            switch error {
            case DecodingError.typeMismatch(_, let context):
              self?.logger.error("\(error.localizedDescription): \(context.debugDescription)")
            case DecodingError.valueNotFound(_, let context):
              self?.logger.error("\(error.localizedDescription): \(context.debugDescription)")
            case DecodingError.keyNotFound(_, let context):
              self?.logger.error("\(error.localizedDescription): \(context.debugDescription)")
            case DecodingError.dataCorrupted(let key):
              self?.logger.error("\(error.localizedDescription): \(key.debugDescription)")
            default:
              self?.logger.error("Error decoding document: \(error.localizedDescription)")
            }
            return nil
          }
        }
      }
  }
  
  func addReminder(_ reminder: Reminder) {
    do {
      var userReminder = reminder
      userReminder.userId = userId
      logger.debug("Adding reminder '\(userReminder.title)' for user \(self.userId)")
      let _ = try db.collection("reminders").addDocument(from: userReminder)
    }
    catch {
      logger.error("Error: \(error.localizedDescription)")
    }
  }
  
  func updateReminder(_ reminder: Reminder) {
    if let documentId = reminder.docId {
      do {
        try db.collection("reminders").document(documentId).setData(from: reminder)
      }
      catch {
        self.logger.debug("Unable to update document \(documentId): \(error.localizedDescription)")
      }
    }
  }
  
  func removeReminder(_ reminder: Reminder) {
    if let documentId = reminder.docId {
      db.collection("reminders").document(documentId).delete() { error in
        if let error = error {
          self.logger.debug("Unable to remove document \(error.localizedDescription)")
        }
      }
    }
  }
  
}
