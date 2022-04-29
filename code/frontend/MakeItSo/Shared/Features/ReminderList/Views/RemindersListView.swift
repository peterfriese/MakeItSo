//
//	RemindersListView.swift
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

struct RemindersListView: View {
  @EnvironmentObject
  var viewModel: RemindersListViewModel
  
  @FocusState
  var focusedReminder: Focusable?
  
  var body: some View {
    List {
      ForEach($viewModel.reminders) { $reminder in
        ReminderListRowView(reminder: $reminder)
          .focused($focusedReminder, equals: .row(id: reminder.id))
          .onSubmit {
            viewModel.createNewReminder()
          }
          .onChange(of: reminder) { value in
            viewModel.updateReminder(reminder)
          }
          .swipeActions {
            Button(role: .destructive, action: { viewModel.deleteReminder(reminder) }) {
              Label("Delete", systemImage: "trash")
            }
            Button(action: { viewModel.flagReminder(reminder) }) {
              Label("Flag", systemImage: "flag")
            }
            .tint(Color(UIColor.systemOrange))
            Button(action: { viewModel.selectedReminder = reminder }) {
              Label("Details", systemImage: "ellipsis")
            }
            .tint(Color(UIColor.systemGray))
          }
      }
    }
    .emptyState($viewModel.reminders.isEmpty) {
      Text("No Reminders")
        .font(.title3)
        .foregroundColor(Color.secondary)
    }
    .sync($viewModel.focusedReminder, $focusedReminder)
    .animation(.default, value: viewModel.reminders)
    .listStyle(.plain)
    .navigationTitle("Reminders")
    .sheet(item: $viewModel.selectedReminder) { reminder in
      ReminderDetailsView(reminder: reminder) { updatedReminder in
        viewModel.updateReminder(updatedReminder)
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        if focusedReminder != nil {
          Button(action: viewModel.unfocus ) {
            Text("Done")
          }
        }
      }
      ToolbarItemGroup(placement: .bottomBar) {
        Button(action: { viewModel.createNewReminder() }) {
          HStack {
            Image(systemName: "plus.circle.fill")
            Text("New Reminder")
          }
        }
        // needed to push the button to the left
        Spacer()
      }
    }
  }
}

struct ReminderssListView_Previews: PreviewProvider {
  static var viewModel = RemindersListViewModel(reminders: Reminder.samples)
  
  static var previews: some View {
    NavigationView {
      RemindersListView()
        .environmentObject(viewModel)
    }
  }
}
