//
//	TaskDetailsView.swift
//  MakeItSo
//
//  Created by Peter Friese on 29.10.21.
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

struct TaskDetailsView: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject private var viewModel: TaskDetailsViewModel
  
  var onCancel: (() -> Void)? = nil
  var onCommit: (Task) -> Void
  
  init(task: Task, onCancel: (() -> Void)? = nil, onCommit: @escaping (Task) -> Void) {
    viewModel = TaskDetailsViewModel(task: task)
    self.onCancel = onCancel
    self.onCommit = onCommit
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Title", text: $viewModel.task.title)
            .lineLimit(5)
          TextField("Notes", text: $viewModel.task.notes)
          TextField("URL", text: $viewModel.task.url)
        }
        
        Section {
          Toggle(isOn: $viewModel.task.hasDueDate) {
            HStack {
              Image(systemName: "calendar")
                .frame(width: 26, height: 26, alignment: .center)
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(4)
              VStack(alignment: .leading) {
                Text("Date")
                Text("Today")
                  .font(.caption2)
                  .foregroundColor(.blue)
              }
            }
          }
          if (viewModel.task.hasDueDate) {
            DatePicker("Date", selection: $viewModel.dueDate, displayedComponents: .date)
              .datePickerStyle(.graphical)
          }
          
          Toggle(isOn: $viewModel.task.hasDueTime) {
            HStack {
              Image(systemName: "clock")
                .frame(width: 26, height: 26, alignment: .center)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(4)
              VStack(alignment: .leading) {
                Text("Time")
                Text("13:00")
                  .font(.caption2)
                  .foregroundColor(.blue)
              }
            }
          }
          if (viewModel.task.hasDueTime) {
            DatePicker("Date", selection: $viewModel.dueTime, displayedComponents: .hourAndMinute)
              .datePickerStyle(.wheel)
          }
        }
        
        Section {
          Text("TODO: Repeat")
        }
        
        Section {
          Text("TODO: Tags")
        }

        Section {
          Text("TODO: Location")
        }
        
        Section {
          Text("TODO: When Messaging")
        }
        
        Section {
          Text("TODO: Flag")
        }
        
        Section {
          Text("TODO: Priority")
        }
        
        Section {
          Text("TODO: Add Image")
        }
      }
      .navigationTitle("Details")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", role: .cancel) {
            onCancel?()
            dismiss()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            onCommit(viewModel.task)
            dismiss()
          }
        }
      }
    }
  }
}

struct TaskDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      Text("Dummy screen content")
        .navigationTitle("Dummy screen")
        .sheet(isPresented: .constant(true)) {
//          TaskDetailsView(task: .constant(Task(title: "Sample")))
//          TaskDetailsView(viewModel: TaskDetailsViewModel(task: Task(title: "Sample task")))
        }
    }
  }
}
