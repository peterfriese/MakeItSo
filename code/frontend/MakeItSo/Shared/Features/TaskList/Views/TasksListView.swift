//
//	TasksListView.swift
//  MakeItSo
//
//  Created by Peter Friese on 26.10.21.
//  Copyright © 2021 Google LLC. All rights reserved.
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

struct TasksListView: View {
  @EnvironmentObject
  var viewModel: TasksListViewModel
  
  @FocusState
  var focusedTask: Focusable?
  
  init() {
    // Turn this into a view modifier. See [Navigation Bar Styling in SwiftUI - YouTube](https://youtu.be/kCJyhG8zjvY)
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemRed]
    UINavigationBar.appearance().standardAppearance = navBarAppearance
  }
  
  var body: some View {
    List {
      ForEach($viewModel.tasks) { $task in
        TaskListRowView(task: $task)
          .accentColor(Color(UIColor.systemRed))
          .focused($focusedTask, equals: .row(id: task.id))
          .onSubmit {
            viewModel.createNewTask()
          }
          .swipeActions {
            Button(role: .destructive, action: { viewModel.deleteTask(task) }) {
              Label("Delete", systemImage: "trash")
            }
            Button(action: { viewModel.flagTask(task) }) {
              Label("Flag", systemImage: "flag")
            }
            .tint(Color(UIColor.systemOrange))
            Button(action: { viewModel.selectedTask = task }) {
              Label("Details", systemImage: "ellipsis")
            }
            .tint(Color(UIColor.systemGray))
          }
      }
    }
    .sync($viewModel.focusedTask, $focusedTask)
    .animation(.default, value: viewModel.tasks)
    .listStyle(.plain)
    .navigationTitle("Tasks")
    .sheet(item: $viewModel.selectedTask) { selecetdTask in
      TaskDetailsView(task: selecetdTask) { task in
        viewModel.updateTask(task)
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .bottomBar) {
        Button(action: { viewModel.createNewTask() }) {
          HStack {
            Image(systemName: "plus.circle.fill")
            Text("New Reminder")
          }
        }
        .accentColor(Color(UIColor.systemRed))
        // needed to push the button to the left
        Spacer()
      }
    }
  }
}

struct TasksListView_Previews: PreviewProvider {
  static var viewModel = TasksListViewModel(tasks: Task.samples)
  
  static var previews: some View {
    NavigationView {
      TasksListView()
        .environmentObject(viewModel)
    }
  }
}
