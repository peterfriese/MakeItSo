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
import Observation
import Factory
import Combine
import FirebaseAuth

@Observable
class UserProfileViewModel {
  @ObservationIgnored
  @Injected(\.authenticationService)
  private var authenticationService

  init() {
    trackChanges()
  }

  private func trackChanges() {
    withObservationTracking {
      self.user = authenticationService.user
    } onChange: {
      Task { @MainActor in
        self.trackChanges()
      }
    }
  }

  var authenticationState: AuthenticationState = .unauthenticated
  var errorMessage = ""

  var user: User? = nil

  var provider: String {
    if let providerData = user?.providerData.first {
      return providerData.providerID
    }
    else {
      return user?.providerID ?? ""
    }
  }

  var displayName: String {
    user?.displayName ?? "N/A"
  }

  var email: String {
    user?.email ?? "N/A"
  }

  var isGuestUser: Bool {
    if let isAnonymous = user?.isAnonymous {
      return isAnonymous
    }
    return false
  }

  var isVerified: Bool {
    guard let user else { return false }
    return user.isEmailVerified
  }

  func deleteAccount() async -> Bool {
    return await authenticationService.deleteAccount()
  }

  func signOut() {
    authenticationService.signOut()
  }
}
