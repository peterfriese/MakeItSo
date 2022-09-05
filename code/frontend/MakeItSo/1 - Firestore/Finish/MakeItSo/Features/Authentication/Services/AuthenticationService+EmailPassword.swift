//
//  AuthenticationService+EmailPassword.swift
//  MakeItSo
//
//  Created by Peter Friese on 29.08.22.
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
import FirebaseAuth

// MARK: - Sign in with Email and Password

extension AuthenticationService {
  
  /// Signs in using an email address and a password.
  /// - Parameters:
  ///   - email: The user's email
  ///   - password: The user's password
  func signIn(withEmail email: String, password: String) async throws {
    
  }

  /// Signs up using an email address and a password. If the current user is an anonymous user,
  /// upgrades the anonymous user to a full account by linking it using the given email and password.
  /// - Parameters:
  ///   - email: The user's email
  ///   - password: The user's password
  func signUp(withEmail email: String, password: String) async throws {
    if let user = user, user.isAnonymous {
      try await link(withEmail: email, password: password)
    }
    else {
      try await Auth.auth().createUser(withEmail: email, password: password)
    }
  }
  
  /// Link email and password credentials to an existing user.
  /// - Parameters:
  ///   - email: The user's email
  ///   - password: The user's password
  func link(withEmail email: String, password: String) async throws {
    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
    let result = try await user?.link(with: credential)
    await MainActor.run {
      self.user = result?.user
    }
  }
}
