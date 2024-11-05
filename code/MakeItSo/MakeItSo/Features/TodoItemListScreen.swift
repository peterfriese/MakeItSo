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

  func addTodoItem () {
    let newTodoItem = TodoItem(
      title: "",
      priority: .none
    )

    if case .row(let id) = focusedItem {
      let existingTodoItem = store.todoItems.first(where: {$0.id == id})
      if let existingTodoItem {
        if existingTodoItem.title.isEmpty {
          store.remove(existingTodoItem)
        }
        else {
          store.insert(newTodoItem, after: existingTodoItem)
        }
      }
    }
    else {
      store.add(newTodoItem)
    }

    if let newTodoItemId = newTodoItem.id {
      focusedItem = .row(id: newTodoItemId)
    }
  }
}

extension TodoItemListScreen {
  var body: some View {
    NavigationStack {
      @Bindable var store = store
      List($store.todoItems) { $todoItem in
        TodoItemRowView(todoItem: $todoItem)
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
            addTodoItem()
          }
          .onChange(of: todoItem) { oldValue, newValue in
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
          Button(action: {addTodoItem()}) {
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

