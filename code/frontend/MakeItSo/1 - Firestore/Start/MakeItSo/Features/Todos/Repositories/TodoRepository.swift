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

  }
  
  func subscribe() {
    
  }
  
  @discardableResult
  func addTodo(_ todo: Todo) -> Todo? {
    return todo
  }
  
  func updateTodo(_ todo: Todo) {

  }
  
  func removeTodo(_ todo: Todo) {
      
  }
  
}
