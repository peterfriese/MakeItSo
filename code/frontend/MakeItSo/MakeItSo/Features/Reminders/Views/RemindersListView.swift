//
// ContentView.swift
// MakeItSo
//
// Created by Peter Friese on 01.03.23.
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
  @StateObject
  private var viewModel = RemindersListViewModel()

  @State
  private var editableReminder: Reminder? = nil

  @State
  private var isAddReminderDialogPresented = false

  private func presentAddReminderView() {
    isAddReminderDialogPresented.toggle()
  }

  @State
  private var isSettingsScreenPresented = false

  private func presentSettingsScreen() {
      isSettingsScreenPresented.toggle()
  }

  var body: some View {
    List($viewModel.reminders) { $reminder in
      RemindersListRowView(reminder: $reminder)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
          Button(role: .destructive, action: { viewModel.deleteReminder(reminder) }) {
            Image(systemName: "trash")
          }
          .tint(Color(UIColor.systemRed))

          Button(action: { viewModel.toggleFlag(reminder) }) {
            Image(systemName: "flag")
          }
          .tint(Color(UIColor.systemOrange))
        }
        .onTapGesture {
          editableReminder = reminder
        }
        .onChange(of: reminder) { newValue in
          viewModel.updateReminder(reminder)
        }
    }
    .listStyle(.plain)
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
          Button(action: presentSettingsScreen) {
              Image(systemName: "gearshape")
          }
      }
      ToolbarItemGroup(placement: .bottomBar) {
        Button(action: presentAddReminderView) {
          HStack {
            Image(systemName: "plus.circle.fill")
            Text("New Reminder")
          }
        }
        Spacer()
      }
    }
    .sheet(item: $editableReminder) { reminder in
      EditReminderView(reminder: reminder) { reminder in
        viewModel.updateReminder(reminder)
      }
    }
    .sheet(isPresented: $isAddReminderDialogPresented) {
      AddReminderView { reminder in
        viewModel.addReminder(reminder)
      }
    }
    .sheet(isPresented: $isSettingsScreenPresented) {
        SettingsView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      RemindersListView()
        .navigationTitle("Reminders")
    }
  }
}
