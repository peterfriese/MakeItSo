//
// SettingsView.swift
// MakeItSo
//
// Created by Peter Friese on 19.05.23.
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

struct SettingsView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel = SettingsViewModel()
  @State var isShowSignUpDialogPresented = false

  private func signUp() {
    isShowSignUpDialogPresented.toggle()
  }

  private func signOut() {
    viewModel.signOut()
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          NavigationLink(destination: UserProfileView()) {
            Label("Account", systemImage: "person.circle")
          }
        }
        Section {
          if viewModel.isGuestUser {
            Button(action: signUp) {
              HStack {
                Spacer()
                Text("Sign up")
                Spacer()
              }
            }
          }
          else {
            Button(action: signOut) {
              HStack {
                Spacer()
                Text("Sign out")
                Spacer()
              }
            }
          }
        } footer: {
          HStack {
            Spacer()
            Text(viewModel.loggedInAs)
            Spacer()
          }
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button(action: { dismiss() }) {
            Text("Done")
          }
        }
      }
      .sheet(isPresented: $isShowSignUpDialogPresented) {
        AuthenticationView()
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
