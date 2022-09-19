//
//  AuthenticationViewModel.swift
//  Favourites
//
//  Created by Peter Friese on 08.07.2022
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
import Foundation
import Resolver
import FirebaseAuth

// For Sign in with Apple
import AuthenticationServices
import CryptoKit

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
  @LazyInjected private var authenticationService: AuthenticationService
  
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var confirmPassword: String = ""

  @Published var flow: AuthenticationFlow = .login

  @Published var isValid: Bool  = false
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage: String = ""
  
  @Published var user: User?
  @Published var displayName: String = ""

  private var currentNonce: String?

  init() {
    authenticationService
      .$user
      .assign(to: &$user)
    
    authenticationService
      .$displayName
      .assign(to: &$displayName)
    
    authenticationService
      .$authenticationState
      .assign(to: &$authenticationState)
    
    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
        ? !(email.isEmpty || password.isEmpty)
        : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)
  }

  func switchFlow() {
    flow = flow == .login ? .signUp : .login
    errorMessage = ""
  }

  func reset() {
    flow = .login
    email = ""
    password = ""
    confirmPassword = ""
  }
}

// MARK: - Generic account operations
extension AuthenticationViewModel {
  func signOut() {
    do {
      try authenticationService.signOut()
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }
  
  func deleteAccount() async -> Bool {
    do {
      try await authenticationService.deleteAccount()
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }
}

// MARK: - Sign in with Email and Password
extension AuthenticationViewModel {
  func signInWithEmailPassword() async -> Bool {
    return false
  }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do  {
      try await authenticationService.signUp(withEmail: email, password: password)
      return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }
}

// MARK: - Sign in with Apple
extension AuthenticationViewModel {

  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest, withStrategy strategy: AuthenticationStrategy = .signIn) {
 
  }

  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {

  }

}
