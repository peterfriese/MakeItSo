//
// AuthenticationService.swift
// MakeItSo
//
// Created by Peter Friese on 26.05.23.
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

public class AuthenticationService {
  @Published var user: User?
  @Published var errorMessage = ""

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  init() {
    registerAuthStateHandler()

    signInAnonymously()
  }

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
      }
    }
  }

  func signOut() {
    do {
      try Auth.auth().signOut()
      signInAnonymously()
    }
    catch {
      print("Error while trying to sign out: \(error.localizedDescription)")
      errorMessage = error.localizedDescription
    }
  }

  func deleteAccount() async -> Bool {
    do {
      try await user?.delete()
      signOut()
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }
}

// MARK: - Sign in anonymously

extension AuthenticationService {
  func signInAnonymously() {
    if Auth.auth().currentUser == nil {
      print("Nobody is signed in. Trying to sign in anonymously.")
      Task {
        do {
          try await Auth.auth().signInAnonymously()
          errorMessage = ""
        }
        catch {
          print("Error when trying to sign in anonymously: \(error.localizedDescription)")
          errorMessage = error.localizedDescription
        }
      }
    }
    else {
      if let user = Auth.auth().currentUser {
        print("Someone is signed in with \(user.providerID) and user ID \(user.uid)")
      }
    }
  }
}



