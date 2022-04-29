//
//	ReminderDetailsView.swift
//  MakeItSo
//
//  Created by Peter Friese on 23.11.21.
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

struct ReminderDetailsView: View {
  @ObservedObject private var viewModel: ReminderDetailsViewModel
  
  private var onCancel: (() -> Void)?
  private var onCommit: (Reminder) -> Void
  
  init(reminder: Reminder, onCancel: (() -> Void)? = nil, onCommit: @escaping (Reminder) -> Void) {
    self.viewModel = ReminderDetailsViewModel(reminder: reminder)
    self.onCommit = onCommit
  }
  
  var body: some View {
    Form {
      Section {
        TextField("Title", text: $viewModel.reminder.title)
        TextField("Notes", text: $viewModel.notes)
        TextField("URL", text: $viewModel.url)
      }
      Section {
        Toggle(isOn: $viewModel.hasDueDate) {
          HStack {
            Image(systemName: "calendar")
              .frame(width: 26, height: 26, alignment: .center)
              .background(.red)
              .foregroundColor(.white)
              .cornerRadius(4)
            VStack(alignment: .leading) {
              Text("Date")
              if viewModel.hasDueDate {
                Text(viewModel.dueDate.formattedRelativeToday())
                  .font(.caption2)
                  .foregroundColor(.blue)
              }            }
          }
        }
        .contentShape(Rectangle())
        .onTapGesture {
          withAnimation {
            viewModel.toggleDatePicker()
          }
        }
        if viewModel.hasDueDate && viewModel.isShowingDatePicker {
          DatePicker("Date", selection: $viewModel.dueDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
        }
        
        Toggle(isOn: $viewModel.hasDueTime) {
          HStack {
            Image(systemName: "clock")
              .frame(width: 26, height: 26, alignment: .center)
              .background(.blue)
              .foregroundColor(.white)
              .cornerRadius(4)
            VStack(alignment: .leading) {
              Text("Time")
              if (viewModel.hasDueTime) {
                Text(viewModel.dueTime, style: .time)
                  .font(.caption2)
                  .foregroundColor(.blue)
              }            }
          }
        }
        .contentShape(Rectangle())
        .onTapGesture {
          withAnimation {
            viewModel.toggleTimePicker()
          }
        }
        if viewModel.hasDueTime && viewModel.isShowingTimePicker {
          DatePicker("Date", selection: $viewModel.dueTime, displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel)
        }
      }
      Section {
        Toggle(isOn: $viewModel.reminder.flagged) {
          HStack {
            Image(systemName: "flag.fill")
              .frame(width: 26, height: 26, alignment: .center)
              .background(.orange)
              .foregroundColor(.white)
              .cornerRadius(4)
            Text("Flag")
          }
        }
      }
      Section {
        Picker("Priority", selection: $viewModel.reminder.priority) {
          ForEach(Priority.allCases) { prio in
            Text(prio.rawValue.capitalized)
          }
        }
      }
    }
    .animation(.default, value: viewModel.reminder)
    .navigationTitle("Details")
    .navigationBarTitleDisplayMode(.inline)
    .confirmationDialog(isModified: viewModel.isModified) {
      onCommit(viewModel.reminder)
    }
  }
}

struct ReminderDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      Text("Dummy screen content")
        .navigationTitle("Dummy screen")
        .sheet(isPresented: .constant(true)) {
          ReminderDetailsView(reminder: Reminder.samples[0]) { updatedReminder in
            print(updatedReminder)
          }
        }
    }
  }
}
