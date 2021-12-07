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
   @StateObject private var viewModel: ReminderDetailsViewModel

   private var onCancel: (() -> Void)?
   private var onCommit: (Reminder) -> Void

   init(reminder: Reminder, onCancel: (() -> Void)? = nil, onCommit: @escaping (Reminder) -> Void) {
      self._viewModel = StateObject(wrappedValue: ReminderDetailsViewModel(reminder: reminder))
      self.onCommit = onCommit
      self.onCancel = onCancel
   }
  
  var body: some View {
    Form {
      Section {
        TextField("Title", text: $viewModel.reminder.title)
        TextField("Notes", text: $viewModel.notes)
        TextField("URL", text: $viewModel.url)
      }
      Section {
        DateTimeSection()
      }
      Section {
          InsetPicker("Repeat", selection: $viewModel.repeatFrequency)
          if viewModel.repeatFrequency != .never {
             DatePicker("EndDate", selection: $viewModel.repeatEndDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
          }
      }
      Section {
          // Tags
          Text("Tags placeholder")
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
        InsetPicker("Priority", selection: $viewModel.reminder.priority)
//        Picker("Priority", selection: $viewModel.reminder.priority) {
//          ForEach(Priority.allCases) { prio in
//            Text(prio.rawValue.capitalized)
//          }
//        }
      }
    }
    .environmentObject(viewModel)
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
