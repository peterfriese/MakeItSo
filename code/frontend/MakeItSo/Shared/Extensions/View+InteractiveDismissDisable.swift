//
//	View+InteractiveDismissDisable.swift
//  MakeItSo (iOS)
//
//  Created by Peter Friese on 25.11.21.
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

extension View {
  public func interactiveDismissDisabled(_ isDisabled: Bool = true, onAttemptToDismiss: (() -> Void)? = nil) -> some View {
    InteractiveDismissableView(view: self, isDisabled: isDisabled, onAttemptToDismiss: onAttemptToDismiss)
  }
  
  public func interactiveDismissDisabled(_ isDisabled: Bool = true, attemptToDismiss: Binding<Bool>) -> some View {
    InteractiveDismissableView(view: self, isDisabled: isDisabled) {
      attemptToDismiss.wrappedValue.toggle()
    }
  }
}

private struct InteractiveDismissableView<T: View>: UIViewControllerRepresentable {
  let view: T
  let isDisabled: Bool
  let onAttemptToDismiss: (() -> Void)?
  
  func makeUIViewController(context: Context) -> UIHostingController<T> {
    UIHostingController(rootView: view)
  }
  
  func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
    context.coordinator.dismissableView = self
    uiViewController.rootView = view
    uiViewController.parent?.presentationController?.delegate = context.coordinator
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
    var dismissableView: InteractiveDismissableView
    
    init(_ dismissableView: InteractiveDismissableView) {
      self.dismissableView = dismissableView
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
      !dismissableView.isDisabled
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
      dismissableView.onAttemptToDismiss?()
    }
  }
}

struct ContentView: View {
  @State var showingSheet = false
  @State var name: String = "Johnny Appleseed"
  var body: some View {
    Form {
      Section("User Profile") {
        Text(name)
      }
      Button("Edit", action: { showingSheet.toggle() })
    }
    .sheet(isPresented: $showingSheet) {
      EditView(name: $name)
    }
  }
}

private class ViewModel: ObservableObject {
  @Published var name: String
  private var original: String
  
  var isModified: Bool {
    print("\(name) - \(original)")
    return name != original
  }
  
  init(name: String) {
    self.name = name
    self.original = name
  }
}

private struct EditView: View {
  @Environment(\.dismiss)  var dismiss
  @Binding var name: String
  
  @StateObject private var viewModel: ViewModel
  @State var showingConfirmationDialog = false
  
  init(name: Binding<String>) {
    self._name = name
    self._viewModel = StateObject(wrappedValue: ViewModel(name: name.wrappedValue))
  }
  
  var body: some View {
    NavigationView {
      Form {
        TextField("Enter your name", text: $viewModel.name)
      }
      .navigationTitle("Edit")
      .navigationBarTitleDisplayMode(.inline)
    }
    .interactiveDismissDisabled(viewModel.isModified) {
      showingConfirmationDialog.toggle()
    }
    .confirmationDialog("", isPresented: $showingConfirmationDialog) {
      Button("Save") {
        name = viewModel.name
        dismiss()
      }
      Button("Discard", role: .destructive) {
        dismiss()
      }
      Button("Cancel", role: .cancel) { }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
