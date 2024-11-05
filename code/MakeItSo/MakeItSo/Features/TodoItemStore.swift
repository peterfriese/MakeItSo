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
import SwiftUI
import FirebaseFirestore

extension EnvironmentValues {
  @Entry var todoItemStore: TodoItemStore = MemoryTodoItemStore()
}

protocol TodoItemStore: Observable, AnyObject {
  var todoItems: [TodoItem] { get }
  func add(_ todoItem: TodoItem)
  func insert (_ todoItem: TodoItem, after: TodoItem)
  func remove(_ todoItem: TodoItem)
  func update(_ todoItem: TodoItem)
  func toggleCompleted(_ todoItem: TodoItem)
  func toggleFlagged(_ todoItem: TodoItem)
}

public class MemoryTodoItemStore: TodoItemStore {
  public var todoItems: [TodoItem] = []

  public func add(_ todoItem: TodoItem) {
    print("Function: \(#function) Thread: \(Thread.isMainThread)")

    todoItems.append(todoItem)
  }

  public func insert (_ todoItem: TodoItem, after: TodoItem) {
    print("Function: \(#function) Thread: \(Thread.isMainThread)")

    if let index = todoItems.firstIndex(of: after) {
      todoItems.insert(todoItem, at: index + 1)
    }
    else {
      todoItems.append(todoItem)
    }
  }

  public func remove(_ todoItem: TodoItem) {
    print("Function: \(#function) Thread: \(Thread.isMainThread)")

    todoItems.removeAll(where: { $0.id == todoItem.id })
  }

  public func update(_ todoItem: TodoItem) {
    print("Function: \(#function) Thread: \(Thread.isMainThread)")

    if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
      todoItems[index] = todoItem
    }
  }

  public func toggleCompleted(_ todoItem: TodoItem) {
    print("Function: \(#function) Thread: \(Thread.isMainThread)")

    if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
      todoItems[index].isCompleted.toggle()
    }
  }

  public func toggleFlagged(_ todoItem: TodoItem) {
    print("Function: \(#function) Thread: \(Thread.isMainThread)")

    if let index = todoItems.firstIndex(of: todoItem) {
      todoItems[index].isFlagged.toggle()
    }
  }
}

@Observable
public class FirestoreTodoItemStore: TodoItemStore {
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?

  public var todoItems: [TodoItem] = []

  init() {
    setupSnapshotListener()
  }

  deinit {
    listenerRegistration?.remove()
  }

  private func setupSnapshotListener() {
    listenerRegistration = db.collection("todoItems").addSnapshotListener { [weak self] querySnapshot, error in
      guard let documents = querySnapshot?.documents else {
        print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
        return
      }

      self?.todoItems = documents.compactMap { queryDocumentSnapshot -> TodoItem? in
        try? queryDocumentSnapshot.data(as: TodoItem.self)
      }
    }
  }

  public func add(_ todoItem: TodoItem) {
    do {
      _ = try db.collection("todoItems").addDocument(from: todoItem)
    } catch {
      print("Error adding todo item: \(error.localizedDescription)")
    }
  }

  func insert(_ todoItem: TodoItem, after: TodoItem) {
  }

  public func remove(_ todoItem: TodoItem) {
    db.collection("todoItems").document(todoItem.id).delete() { error in
      if let error = error {
        print("Error removing todo item: \(error.localizedDescription)")
      }
    }
  }

  public func update(_ todoItem: TodoItem) {
    do {
      try db.collection("todoItems").document(todoItem.id).setData(from: todoItem)
    } catch {
      print("Error updating todo item: \(error.localizedDescription)")
    }
  }

  public func toggleCompleted(_ todoItem: TodoItem) {
    var updatedItem = todoItem
    updatedItem.isCompleted.toggle()
    update(updatedItem)
  }

  public func toggleFlagged(_ todoItem: TodoItem) {
    var updatedItem = todoItem
    updatedItem.isFlagged.toggle()
    update(updatedItem)
  }
}
