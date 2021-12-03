//
//	ReminderListRowView.swift
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

struct ReminderListRowView: View {
  @ObservedObject var viewModel: ReminderListRowViewModel
  
  init(reminder: Binding<Reminder>) {
    viewModel = ReminderListRowViewModel(reminder: reminder)
  }
  
  var body: some View {
    HStack(alignment: .top) {
      Image(systemName: viewModel.reminder.completed ? "checkmark.circle.fill" : "circle")
        .foregroundColor(viewModel.reminder.completed ? Color(UIColor.systemRed) : .gray)
        .font(.title3)
        .onTapGesture {
          viewModel.reminder.completed.toggle()
        }
      VStack(alignment: .leading) {
        HStack {
          if viewModel.reminder.priority > .none {
            Text(viewModel.priorityAdornment)
              .foregroundColor(.accentColor)
          }
          TextField("", text: $viewModel.reminder.title)
            .padding(.trailing, viewModel.reminder.flagged ? 20 : 0)
            .overlay {
              if viewModel.reminder.flagged {
                HStack {
                  Spacer()
                  Image(systemName: "flag.fill")
                    .foregroundColor(Color(UIColor.systemOrange))
                }
              }
            }
        }
        if viewModel.hasDueDate {
          Text(viewModel.formattedDueDate)
            .font(.caption)
            .foregroundColor(Color(UIColor.systemGray))
        }
      }
    }
  }
}

struct ReminderListRowView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        ReminderListRowView(reminder: .constant(Reminder.samples[0]))
        ReminderListRowView(reminder: .constant(Reminder.samples[1]))
        ReminderListRowView(reminder: .constant(Reminder.samples[2]))
      }
      .listStyle(.plain)
      .navigationTitle("Reminders")
    }
  }
}
