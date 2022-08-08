//
//  TodoRepository.swift
//  MakeItSo
//
//  Created by Peter Friese on 26.07.22.
//  Copyright © 2022 Google LLC. All rights reserved.
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

class TodosRepository: ObservableObject {
  // MARK: - Dependencies
  @Injected var db: Firestore
  @Injected var authenticationService: AuthenticationService
  
  // MARK: - Publishers
  @Published public var todos = [Todo]()

  // MARK: - Private attributes
  private var userId: String = "unknown"
  private var listenerRegistration: ListenerRegistration?
  private var cancellables = Set<AnyCancellable>()
  
  let logger = Logger(subsystem: "com.google.firebase.workshop.MakeItSo", category: "persistence")
  
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
    
    subscribe()
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
    let query = db.collection("todos")
      .whereField("userId", isEqualTo: userId)

    listenerRegistration = query
      .addSnapshotListener { [weak self] (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          self?.logger.debug("No documents in 'todos' collection")
          return
        }
        
        self?.todos = documents.compactMap { queryDocumentSnapshot in
          let result = Result { try queryDocumentSnapshot.data(as: Todo.self) }

          switch result {
          case .success(let todo):
            // A `Todo` value was successfully initialized from the DocumentSnapshot.
            return todo
          case .failure(let error):
            // A `Todo` value could not be initialized from the DocumentSnapshot.
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
  
  // TODO clean this up
  @discardableResult
  func addTodo(_ todo: Todo) -> Todo? {
    do {
      var userTodo = todo
      userTodo.userId = userId
      logger.debug("Adding todo '\(userTodo.title)' for user \(self.userId)")
      let documentReference = try db.collection("todos").addDocument(from: userTodo)
      userTodo.docId = documentReference.documentID
      return userTodo
    }
    catch {
      logger.error("Error: \(error.localizedDescription)")
      return todo
    }
  }
  
  func updateTodo(_ todo: Todo) {
    if let documentId = todo.docId {
      do {
        try db.collection("todos").document(documentId).setData(from: todo)
      }
      catch {
        self.logger.debug("Unable to update document \(documentId): \(error.localizedDescription)")
      }
    }
  }
  
  func removeTodo(_ todo: Todo) {
    if let documentId = todo.docId {
      db.collection("todos").document(documentId).delete() { error in
        if let error = error {
          self.logger.debug("Unable to remove document \(error.localizedDescription)")
        }
      }
    }
  }
  
}
