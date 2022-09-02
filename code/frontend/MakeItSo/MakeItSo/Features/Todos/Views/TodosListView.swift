//
//  TodoListView.swift
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

import SwiftUI

struct TodosListView: View {
  @StateObject private var viewModel = TodosListViewModel()
  @State private var presentingSetttingsScreen = false
  @State private var path = [Todo]()
  
  var body: some View {
    NavigationView {
      List($viewModel.todos) { $todo in
        NavigationLink(destination: TodoDetailsView(todo: todo)) {
          TodoListRowView(todo: $todo)
        }
        .swipeActions {
          Button(role: .destructive, action: { viewModel.removeTodo(todo) }) {
            Label("Delete", systemImage: "trash")
          }
          if (viewModel.showDetailsButton) {
            Button(action: { path = [todo] }) {
              Label("Details", systemImage: "ellipsis")
            }
            .tint(Color(UIColor.systemGray))
          }
        }
      }
      .listStyle(.plain)
      .navigationTitle("Todos")
//      .navigationDestination(for: Todo.self) { todo in
//        TodoDetailsView(todo: todo)
//      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { presentingSetttingsScreen.toggle() }) {
            Image(systemName: "gear")
          }
        }
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button(action: newTodo) {
            Image(systemName: "plus")
          }
        }
      }
      .sheet(isPresented: $presentingSetttingsScreen) {
        SettingsView()
      }
    }
  }
  
  private func newTodo() {
    let todo = viewModel.createTodo()
    path = [todo]
  }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TodosListView()
    }
  }
}
