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

struct TodoItemListScreen: View {
  @State var todoItems = TodoItem.mockList
  @State var store = MemoryTodoItemStore()

  init () {
    store.todoItems = TodoItem.mockList
  }

  func addTodoItem () {
    store.todoItems
      .append(
        .init(id: UUID().uuidString, title: "New Todo Item", priority: .none)
      )
  }
}

extension TodoItemListScreen {
  var body: some View {
    NavigationStack {
      List($store.todoItems) { $todoItem in
        TodoItemRowView(todoItem: $todoItem)
      }
      .listStyle(.plain)
      .navigationTitle("Make It So")
      .toolbar {
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

