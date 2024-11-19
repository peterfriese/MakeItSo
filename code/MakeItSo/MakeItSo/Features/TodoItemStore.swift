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
  @Entry var todoItemStore: TodoItemStore = TodoItemStore(storage: InMemoryStorageStrategy())
}

protocol TodoItemStorageStrategy: Observable, AnyObject {
  var todoItems: [TodoItem] { get set }
  func add(_ todoItem: TodoItem)
  func insert (_ todoItem: TodoItem, after: TodoItem)
  func remove(_ todoItem: TodoItem)
  func update(_ todoItem: TodoItem)
  func toggleCompleted(_ todoItem: TodoItem)
  func toggleFlagged(_ todoItem: TodoItem)
}

@Observable
public class InMemoryStorageStrategy: TodoItemStorageStrategy {
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
public class FirebaseStorageStrategy: TodoItemStorageStrategy {
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
    listenerRegistration = db
      .collection("todoitems")
      .order(by: "order")
      .addSnapshotListener { [weak self] querySnapshot, error in
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
    var newTodoItem = todoItem
    newTodoItem.order = todoItems.computeOrder(for: newTodoItem)
    todoItems.append(newTodoItem)

    do {
      _ = try db.collection("todoitems").addDocument(from: newTodoItem)
    } catch {
      print("Error adding todo item: \(error.localizedDescription)")
    }
  }

  func insert(_ todoItem: TodoItem, after: TodoItem) {
    var newTodoItem = todoItem
    if let index = todoItems.firstIndex(where: { $0.id == after.id } ) {
      newTodoItem.order = todoItems.computeOrder(for: todoItem, after: index)
      todoItems.insert(newTodoItem, at: index + 1)
    }

    do {
      _ = try db.collection("todoitems").addDocument(from: newTodoItem)
    } catch {
      print("Error adding todo item: \(error.localizedDescription)")
    }
  }

  public func remove(_ todoItem: TodoItem) {
    if let index = todoItems.firstIndex(of: todoItem) {
      todoItems.remove(at: index)
    }
    if let documentId = todoItem.docId {
      db.collection("todoitems").document(documentId).delete() { error in
        if let error = error {
          print("Error removing todo item: \(error.localizedDescription)")
        }
      }
    }
  }

  public func update(_ todoItem: TodoItem) {
    do {
      if let documentId = todoItem.docId {
        try db.collection("todoitems").document(documentId).setData(from: todoItem)
      }
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

@Observable
public class TodoItemStore: TodoItemStorageStrategy {
  private var storage: TodoItemStorageStrategy

  public var todoItems: [TodoItem] {
    get { storage.todoItems }
    set { storage.todoItems = newValue }
  }

  init(storage: TodoItemStorageStrategy) {
    self.storage = storage
  }

  public func add(_ todoItem: TodoItem) {
    storage.add(todoItem)
  }

  public func insert(_ todoItem: TodoItem, after: TodoItem) {
    storage.insert(todoItem, after: after)
  }

  public func remove(_ todoItem: TodoItem) {
    storage.remove(todoItem)
  }

  public func update(_ todoItem: TodoItem) {
    storage.update(todoItem)
  }

  public func toggleCompleted(_ todoItem: TodoItem) {
    storage.toggleCompleted(todoItem)
  }

  public func toggleFlagged(_ todoItem: TodoItem) {
    storage.toggleFlagged(todoItem)
  }
}
