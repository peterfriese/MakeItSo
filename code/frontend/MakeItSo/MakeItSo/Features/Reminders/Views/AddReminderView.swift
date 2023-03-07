//
// AddReminderVIew.swift
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

struct AddReminderView: View {
  enum FocusableField: Hashable {
    case title
  }

  @Environment(\.dismiss)
  private var dismiss

  @FocusState
  private var focusedField: FocusableField?

  @State
  private var reminder = Reminder(title: "")

  var completion: (_ reminder: Reminder) -> Void

  private func commit() {
    completion(reminder)
    dismiss()
  }

  private func cancel() {
    dismiss()
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Title", text: $reminder.title)
            .focused($focusedField, equals: .title)
        }
        Section {
          Text("Details")
        }
      }
      .navigationTitle("New Reminder")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(action: cancel) {
            Text("Cancel")
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(action: commit) {
            Text("Add")
          }
          .disabled(reminder.title.isEmpty)
        }
      }
      .onAppear {
        focusedField = .title
      }
    }
  }
}

struct AddReminderView_Previews: PreviewProvider {
  static var previews: some View {
    Text("Dummy")
      .sheet(isPresented: .constant(true)) {
        AddReminderView { title in
          print("You added a new item with title '\(title)'")
        }
      }
  }
}
