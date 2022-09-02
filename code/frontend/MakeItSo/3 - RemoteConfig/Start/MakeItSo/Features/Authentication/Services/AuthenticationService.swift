//
//  AuthenticationService.swift
//  MakeItSo
//
//  Created by Peter Friese on 26.07.22.
//  Copyright © 2022 Google LLC. All rights reserved.
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
import os
import Resolver
import FirebaseCore
import FirebaseAuth
import Combine

public class AuthenticationService: ObservableObject {
  private let logger = Logger(subsystem: "com.google.firebase.workshop.MakeItSo", category: "authentication")
  
  @Published var user: User?
  @Published var displayName: String = ""
  @Published var authenticationState: AuthenticationState = .unauthenticated
  
  private var authStateHandler: AuthStateDidChangeListenerHandle?
  internal var currentNonce: String?
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    registerAuthStateHandler()
    verifySignInWithAppleAuthenticationState()
    registerCredentialRevocationListener()
    
    $user
      .map { user in
        user?.displayName ?? user?.email ?? ""
      }
      .assign(to: &$displayName)
    
    $user
      .sink { user in
        if user == nil {
          self.logger.debug("User signed out.")
          // sign in anonymously
          self.signIn()
        }
      }
      .store(in: &cancellables)
    
    $user
      .compactMap { $0 }
      .map { user in
        user.isAnonymous
          ? AuthenticationState.unauthenticated
          : .authenticated
      }
      .assign(to: &$authenticationState)
  }
  
  private func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
      }
    }
  }
  
}

// MARK: - Generic account operations
extension AuthenticationService {
  
  /// If no user is signed in, sign in anonymously
  func signIn() {
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously()
    }
  }
  
  func signOut() throws {
    try Auth.auth().signOut()
  }
  
  func deleteAccount() async throws {
    try await user?.delete()
  }
}
