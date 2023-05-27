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
import FirebaseAuth
import Combine

class SettingsViewModel: ObservableObject {
  @Published var user: User?
  @Published var displayName = ""

  @Published var isGuestUser = false

  @Published var loggedInAs = ""

  init() {
    $user
      .compactMap { user in
        user?.isAnonymous
      }
      .assign(to: &$isGuestUser)

    $user
      .compactMap { user in
        user?.displayName ?? user?.email ?? ""
      }
      .assign(to: &$displayName)

    Publishers.CombineLatest($isGuestUser, $displayName)
      .map { isGuest, displayName in
        isGuest
          ? "You're using the app as a guest"
          : "Logged in as \(displayName)"
      }
      .assign(to: &$loggedInAs)
  }

  func signOut() {
    fatalError("Not implemented yet")
  }
}
