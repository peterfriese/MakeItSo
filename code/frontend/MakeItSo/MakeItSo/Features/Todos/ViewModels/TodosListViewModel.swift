//
//  TodosListViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 27.07.22.
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
import Resolver

class TodosListViewModel: ObservableObject {
  @Published var todos = [Todo]()
  @Published var showDetailsButton: Bool = ConfigurationDefaults.showDetailsButtonValue
  
  @LazyInjected private var repository: TodosRepository
  @LazyInjected private var configurationService: ConfigurationService
  
  init() {
    repository
      .$todos
      .assign(to: &$todos)
      
      configurationService
        .$showDetailsButton
        .assign(to: &$showDetailsButton)
  }
  
  func addTodo(_ todo: Todo) {
    repository.addTodo(todo)
  }
  
  func createTodo() -> Todo {
    let todo = Todo(title: "New todo")
    return repository.addTodo(todo) ?? todo
  }
  
  func updateTodo(_ todo: Todo) {
    repository.updateTodo(todo)
  }
  
  func removeTodo(_ todo: Todo) {
    repository.removeTodo(todo)
  }
  
}
