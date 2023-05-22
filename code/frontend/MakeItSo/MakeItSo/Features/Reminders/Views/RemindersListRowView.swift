//
// RemindersListRowView.swift
// MakeItSo
//
// Created by Peter Friese on 16.05.23.
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

struct RemindersListRowView: View {
  @Binding
  var reminder: Reminder

  var body: some View {
    HStack {
      Toggle(isOn: $reminder.isCompleted) { /* no label, on purpose */}
        .toggleStyle(.reminder)
      Text(reminder.title)
      Spacer()
    }
    .contentShape(Rectangle())
  }
}

struct RemindersListRowView_Previews: PreviewProvider {
  struct Container: View {
    @State var reminder = Reminder.samples[0]
    var body: some View {
      List {
        RemindersListRowView(reminder: $reminder)
      }
    }
  }

  static var previews: some View {
    NavigationStack {
      Container()
        .listStyle(.plain)
        .navigationTitle("Reminder")
    }
  }
}
