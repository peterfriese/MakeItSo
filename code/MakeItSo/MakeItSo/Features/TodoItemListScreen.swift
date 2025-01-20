//
// TodoItemListScreen.swift
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

import SwiftUI

enum Focusable: Hashable {
  case row(id: String?)
}

struct TodoItemListScreen: View {
  @Environment(TodoItemStore.self) var store
  @FocusState var focusedItem: Focusable?

  func focusedTodoItem() -> TodoItem? {
    guard case let .row(id) = focusedItem, let id else { return nil }
    return store.todoItems.first(where: { $0.id == id })
  }

  // TODO: this does more than just adding the new item. It also updates the current todo item (the one the cursors sits in).
  // This is required since we debounce updating the current todo item.
  // Might need to find a better way to implement this
  func createNewTodoItem(append: Bool = false) {
    let newTodoItem = TodoItem(
      title: "",
      priority: .none
    )

    Task {
      if let item = focusedTodoItem() {
        if item.title.isEmpty {
          if append {
            // If empty item is not at the end, remove it and append new one
            let isLastItem = store.todoItems.last?.id == item.id
            if !isLastItem {
              store.remove(item)
              let addedItem = await store.add(newTodoItem)
              focusedItem = .row(id: addedItem.id)
            }
            // Otherwise, keep using current empty one (no-op)
          } else {
            store.remove(item)
            focusedItem = nil
          }
        } else {
          // Title is not empty, update current and add new
          if append {
            let addedItem = await store.add(newTodoItem)
            focusedItem = .row(id: addedItem.id)
          } else {
            store.update(item)
            let insertedItem = await store.insert(newTodoItem, after: item)
            focusedItem = .row(id: insertedItem.id)
          }
        }
      } else if append {
        // No focused item, just append
        let addedItem = await store.add(newTodoItem)
        focusedItem = .row(id: addedItem.id)
      } else {
        focusedItem = nil
      }
    }
  }
}

extension TodoItemListScreen {
  var body: some View {
    NavigationStack {
      @Bindable var store = store
      List($store.todoItems) { $todoItem in
        TodoItemRowView(todoItem: $todoItem)
          .id(todoItem.id)
          .focused($focusedItem, equals: .row(id: todoItem.id))
          .swipeActions {
            Button(role: .destructive, action: { store.remove(todoItem) }) {
              Label("Delete", systemImage: "trash")
            }
            Button(action: { store.toggleFlagged(todoItem) }) {
              Label("Flag", systemImage: "flag")
            }
            .tint(Color(UIColor.systemOrange))
          }
          .onSubmit {
            withAnimation {
              createNewTodoItem()
            }
          }
          .task(id: todoItem, debounce: .milliseconds(600)) {
            store.update(todoItem)
          }
      }
      .listStyle(.plain)
      .navigationBarTitle("Make It So")
      .navigationBarTitleFontDesign(.rounded, color: .accentColor)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          if focusedItem != nil {
            Button("Done") {
              focusedItem = nil
            }
          }
        }
        ToolbarItem(placement: .bottomBar) {
          Button(action: { createNewTodoItem(append: true) }) {
            HStack {
              Image(systemName: "plus.circle.fill")
                .font(.title2)
              Text("New to-do")
            }
          }
        }
        ToolbarItem(placement: .bottomBar) {
          Spacer()
        }
      }
    }
  }
}

#Preview {
  TodoItemListScreen()
}
