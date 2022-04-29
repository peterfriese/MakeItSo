//
//	View+ConfirmationDialog.swift
//  MakeItSo (iOS)
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

struct ConfirmationDialog: ViewModifier {
  @Environment(\.dismiss) private var dismiss
  @State private var presentingConfirmationDialog: Bool = false
  
  var isModified: Bool
  var onCancel: (() -> Void)?
  var onCommit: () -> Void
  
  private func doCancel() {
    onCancel?()
    dismiss()
  }
  
  private func doCommit() {
    onCommit()
    dismiss()
  }
  
  func body(content: Content) -> some View {
    NavigationView {
      content
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel) {
              if isModified {
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
        .confirmationDialog("", isPresented: $presentingConfirmationDialog) {
          Button("Discard Changes", role: .destructive, action: doCancel)
          Button("Cancel", role: .cancel, action: { })
        }
    }
    // Option 1: use a closure to handle the attempt to dismiss
//    .interactiveDismissDisabled(isModified) {
//      presentingConfirmationDialog.toggle()
//    }
    // Option 2: bind attempt to dismiss to a boolean state variable that drives the UI
    .interactiveDismissDisabled(isModified, attemptToDismiss: $presentingConfirmationDialog)
  }
}

extension View {
  func confirmationDialog(isModified: Bool, onCancel: (() -> Void)? = nil, onCommit: @escaping () -> Void) -> some View {
    self.modifier(ConfirmationDialog(isModified: isModified,  onCancel: onCancel, onCommit: onCommit))
  }
}

