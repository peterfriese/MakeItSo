//
// TodoItemsStore.swift
// MakeItSo
//
// Created by Peter Friese on 21.10.24.
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
import Observation

protocol TodoItemStore {
  var todoItems: [TodoItem] { get }
  func add(_ todoItem: TodoItem) async
  func remove(_ todoItem: TodoItem) async
  func update(_ todoItem: TodoItem) async
  func toggleCompleted(_ todoItem: TodoItem) async
}

@Observable
public class MemoryTodoItemStore: TodoItemStore {
  public var todoItems: [TodoItem] = []

  public func add(_ todoItem: TodoItem) {
    var newItem = todoItem
    if newItem.id == nil {
      newItem.id = UUID().uuidString
    }
    todoItems.append(newItem)
  }

  public func remove(_ todoItem: TodoItem) {
    todoItems.removeAll(where: { $0.id == todoItem.id })
  }

  public func update(_ todoItem: TodoItem) {
    if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
      todoItems[index] = todoItem
    }
  }

  public func toggleCompleted(_ todoItem: TodoItem) {
    if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
      todoItems[index].isCompleted.toggle()
    }
  }
}
