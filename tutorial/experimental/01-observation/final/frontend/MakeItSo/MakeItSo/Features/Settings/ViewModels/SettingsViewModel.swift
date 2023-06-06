//
// SettingsViewModel.swift
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

import Foundation
import Factory
import Observation
import FirebaseAuth
import Combine

@Observable
class SettingsViewModel {
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

  var user: User? = nil

  var displayName: String {
    user?.displayName ?? user?.email ?? ""
  }

  var isGuestUser: Bool {
    user?.isAnonymous != nil
  }

  var loggedInAs: String {
    return isGuestUser
      ? "You're using the app as a guest"
      : "Logged in as \(displayName)"
  }

  func signOut() {
    authenticationService.signOut()
  }
}
