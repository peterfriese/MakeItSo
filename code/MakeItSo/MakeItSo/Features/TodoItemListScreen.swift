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

  func createNewTodoItem(current: TodoItem?) {
    let newTodoItem = TodoItem(
      title: "",
      priority: .none
    )

    if let current {
      if current.title.isEmpty {
        store.remove(current)
      }
      else {
        store.update(current)
        store.insert(newTodoItem, after: current)
      }
    }
    else {
      store.add(newTodoItem)
    }

    Task {
      // We need to wait a short moment for the item to show up before we can focus it.
      // I assume this is to make sure SwiftUI can do one rendering pass.
      try await Task.sleep(for: .milliseconds(100))
      focusedItem = .row(id: newTodoItem.id)
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
//            withAnimation {
              createNewTodoItem(current: todoItem)
//            }
          }
          .task(id: todoItem, debounce: .milliseconds(600)) {
            // TODO: this results in an Index Out of Bounds exception when the item
            // has just been removed in `createNewTodoItem`, but only if `createNewTodoItem`
            // is wrapped inside `withAnimation`
            store.update(todoItem)
          }
      }
      .listStyle(.plain)
      .navigationBarTitle("Make It So")
      .navigationBarTitleFontDesign(.rounded, color: .accentColor)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          if focusedItem != nil {
            Button(action: {
              focusedItem = nil
            }) {
              Text("Done")
            }
          }
        }
        ToolbarItem(placement: .bottomBar) {
          Button(action: { createNewTodoItem(current: nil) }) {
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
