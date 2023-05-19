//
// UserProfileView.swift
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
import FirebaseAnalyticsSwift
import FirebaseAuth
import Combine
import Factory

class UserProfileViewModel: ObservableObject {
  @Injected(\.authenticationService)
  private var authenticationService
  
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var provider = ""
  @Published var displayName = ""
  @Published var email = ""
  
  @Published var isGuestUser = false
  @Published var isVerified = false
  
  init() {
    authenticationService.$user
      .assign(to: &$user)
    
    $user
      .compactMap { user in
        user?.isAnonymous
      }
      .assign(to: &$isGuestUser)
    
    $user
      .compactMap { user in
        user?.isEmailVerified
      }
      .assign(to: &$isVerified)
    
    $user
      .compactMap { user in
        user?.displayName ?? "N/A"
      }
      .assign(to: &$displayName)
    
    $user
      .compactMap { user in
        user?.email ?? "N/A"
      }
      .assign(to: &$email)
    
    $user
      .compactMap { user in
        if let providerData = user?.providerData.first {
          return providerData.providerID
        }
        else {
          return user?.providerID
        }
      }
      .assign(to: &$provider)
    
  }
  
  func deleteAccount() async -> Bool {
    return await authenticationService.deleteAccount()
  }
  
  func signOut() {
    authenticationService.signOut()
  }
}

struct UserProfileView: View {
  @StateObject var viewModel = UserProfileViewModel()
  @Environment(\.dismiss) var dismiss
  @State var presentingConfirmationDialog = false
  
  private func deleteAccount() {
    Task {
      if await viewModel.deleteAccount() == true {
        dismiss()
      }
    }
  }
  
  private func signOut() {
    viewModel.signOut()
  }
  
  var body: some View {
    Form {
      Section {
        VStack {
          HStack {
            Spacer()
            Image(systemName: "person.fill")
              .resizable()
              .frame(width: 100 , height: 100)
              .aspectRatio(contentMode: .fit)
              .clipShape(Circle())
              .clipped()
              .padding(4)
              .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
            Spacer()
          }
          Button(action: {}) {
            Text("edit")
          }
        }
      }
      .listRowBackground(Color(UIColor.systemGroupedBackground))
      Section("Email") {
        VStack(alignment: .leading) {
          Text("Name")
            .font(.caption)
          Text(viewModel.displayName)
        }
        VStack(alignment: .leading) {
          Text("Email")
            .font(.caption)
          Text(viewModel.email)
        }
        VStack(alignment: .leading) {
          Text("UID")
            .font(.caption)
          Text(viewModel.user?.uid ?? "(unknown)")
        }
        VStack(alignment: .leading) {
          Text("Provider")
            .font(.caption)
          Text(viewModel.provider)
        }
        VStack(alignment: .leading) {
          Text("Anonymous / Guest user")
            .font(.caption)
          Text(viewModel.isGuestUser ? "Yes" : "No")
        }
        VStack(alignment: .leading) {
          Text("Verified")
            .font(.caption)
          Text(viewModel.isVerified ? "Yes" : "No")
        }
      }
      Section {
        Button(role: .cancel, action: signOut) {
          HStack {
            Spacer()
            Text("Sign out")
            Spacer()
          }
        }
      }
      Section {
        Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
          HStack {
            Spacer()
            Text("Delete Account")
            Spacer()
          }
        }
      }
    }
    .navigationTitle("Profile")
    .navigationBarTitleDisplayMode(.inline)
    .analyticsScreen(name: "\(Self.self)")
    .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                        isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
      Button("Delete Account", role: .destructive, action: deleteAccount)
      Button("Cancel", role: .cancel, action: { })
    }
  }
}

struct UserProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UserProfileView()
    }
  }
}
