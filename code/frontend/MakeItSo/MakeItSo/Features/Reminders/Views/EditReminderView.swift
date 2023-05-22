//
// EditReminderView.swift
// MakeItSo
//
// Created by Peter Friese on 22.05.23.
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

struct EditReminderView: View {
  enum FocusableField: Hashable {
    case title
  }

  @FocusState
  private var focusedField: FocusableField?

  @State
  var reminder: Reminder

  @Environment(\.dismiss)
  private var dismiss

  let onCommit: (_ reminder: Reminder) -> Void

  private func commit() {
    onCommit(reminder)
    dismiss()
  }

  private func cancel() {
    dismiss()
  }

  var body: some View {
    NavigationStack {
      Form {
        TextField("Title", text: $reminder.title)
          .focused($focusedField, equals: .title)
          .onSubmit {
            commit()
          }
      }
      .navigationTitle("Details")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(action: cancel) {
            Text("Cancel")
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(action: commit) {
            Text("Done")
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

struct EditReminderView_Previews: PreviewProvider {
  struct Container: View {
    @State var reminder = Reminder.samples[0]
    var body: some View {
      EditReminderView(reminder: reminder) { reminder in
        print("You edited a reminder: \(reminder.title)")
      }
    }
  }

  static var previews: some View {
    NavigationStack {
      Container()
        .navigationTitle("Reminder")
    }
  }
}