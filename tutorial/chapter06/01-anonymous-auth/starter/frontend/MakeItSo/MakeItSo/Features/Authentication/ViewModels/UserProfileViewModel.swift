//
// UserProfileViewModel.swift
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
import Factory
import Combine
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var provider = ""
  @Published var displayName = ""
  @Published var email = ""

  @Published var isGuestUser = false
  @Published var isVerified = false

  init() {
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
    fatalError("Not implemented yet")
  }

  func signOut() {
    fatalError("Not implemented yet")
  }
}
