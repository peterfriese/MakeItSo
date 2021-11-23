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
  @Environment(\.dismiss) private var dismiss
  @ObservedObject private var viewModel: ReminderDetailsViewModel
  
  private var onCancel: (() -> Void)?
  private var onCommit: (Reminder) -> Void
  
  @State private var presentingConfirmationDialog: Bool = false
  
  init(reminder: Reminder, onCancel: (() -> Void)? = nil, onCommit: @escaping (Reminder) -> Void) {
    self.viewModel = ReminderDetailsViewModel(reminder: reminder)
    self.onCommit = onCommit
  }
  
  func doCancel() {
    onCancel?()
    dismiss()
  }
  
  func doCommit() {
    onCommit(viewModel.reminder)
    dismiss()
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Title", text: $viewModel.reminder.title)
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
      }
      .navigationTitle("Details")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", role: .cancel) {
            if viewModel.isModified {
              presentingConfirmationDialog.toggle()
            }
            else {
              doCancel()
            }
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Done", action: doCommit)
        }
      }
      .interactiveDismissDisabled(viewModel.isModified)
      .confirmationDialog("", isPresented: $presentingConfirmationDialog) {
        Button("Discard Changes", role: .destructive, action: doCancel)
        Button("Cancel", role: .cancel, action: { })
      }
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
