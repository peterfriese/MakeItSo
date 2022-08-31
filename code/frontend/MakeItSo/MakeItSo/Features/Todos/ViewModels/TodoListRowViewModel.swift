//
//  TodoListRowViewModel.swift
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
import SwiftUI
import Resolver

class TodoListRowViewModel: ObservableObject {
  @Published var todoCheckShape: String = ConfigurationDefaults.todoCheckShapeValue
    
  @LazyInjected private var repository: TodosRepository
  @LazyInjected private var configurationService: ConfigurationService
  
  @Binding var todo: Todo
  
  init(todo: Binding<Todo>) {
    self._todo = todo
      
    configurationService
      .$todoCheckShape
      .filter { $0 == "circle" || $0 == "square" }
      .assign(to: &$todoCheckShape)
  }
  
  func toggleCompletion() {
    var userTodo = todo
    userTodo.completed.toggle()
    repository.updateTodo(userTodo)
  }
  
}
