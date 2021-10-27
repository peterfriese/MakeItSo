//
//	TaskListRowView.swift
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

struct TaskListRowView: View {
  @Binding var task: Task
  
  var body: some View {
    HStack {
      Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
        .foregroundColor(task.completed ? Color(UIColor.systemRed) : .gray)
        .font(.title3)
        .onTapGesture {
          task.completed.toggle()
        }
      TextField("", text: $task.title)
        .padding(.trailing, task.flagged ? 20 : 0)
        .overlay {
          if task.flagged {
          HStack {
            Spacer()
            Image(systemName: "flag.fill")
              .foregroundColor(Color(UIColor.systemOrange))
          }
          }
        }
    }
  }
}

struct TaskListRowView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        TaskListRowView(task: .constant(Task.samples[0]))
      }
      .listStyle(.plain)
      .navigationTitle("Tasks")
    }
  }
}
