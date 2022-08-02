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

// MARK: - Sign in with Email and Password

extension AuthenticationViewModel {
  func signInWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do {
      try await authenticationService.signIn(withEmail: email, password: password)
      return true
    }
    catch  {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do  {
//      try await authenticationService.signUp(withEmail: email, password: password)
      try await authenticationService.link(withEmail: email, password: password)
      return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

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

// MARK: - Sign in with Apple

enum SignInState: String {
  case signIn
  case link
  case reauth
}

extension AuthenticationViewModel {

  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest, withState: SignInState = .signIn) {
    request.requestedScopes = [.fullName, .email]
    
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
    
    request.state = withState.rawValue
  }

  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    if case .failure(let failure) = result {
      errorMessage = failure.localizedDescription
    }
    else if case .success(let authorization) = result {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: a login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetdch identify token.")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
          return
        }
        guard let stateRaw = appleIDCredential.state, let state = SignInState(rawValue: stateRaw) else {
          print("Invalid state: request must be started with one of the SignInStates")
          return
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        
        switch state {
        case .signIn:
          Task {
            do {
              let result = try await Auth.auth().signIn(with: credential)
              try await result.user.updateDisplayName(with: appleIDCredential)
              displayName = result.user.displayName ?? ""
            }
            catch {
              print("Error: \(error.localizedDescription)")
            }
          }
        case .link:
          guard let currentUser = Auth.auth().currentUser else { return }
          Task {
            do {
              let result = try await currentUser.link(with: credential)
              try await result.user.updateDisplayName(with: appleIDCredential)
              displayName = result.user.displayName ?? ""
            }
            catch {
              print("Error: \(error.localizedDescription)")
              if (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                print("The user you're signing in with has already been linked, signing in to the new user and migrating the anonymous users [\(currentUser.uid)] tasks.")
                guard let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential else { return }
                print("Signing in using the updated credential")
                do {
                  let result = try await Auth.auth().signIn(with: updatedCredential)
                  try await result.user.updateDisplayName(with: appleIDCredential)
                  displayName = result.user.displayName ?? ""
                }
                catch {
                  print("Error: \(error.localizedDescription)")
                }
              }
            }
          }
        case .reauth:
          guard let currentUser = Auth.auth().currentUser else { return }
          Task {
            do {
              let result = try await currentUser.reauthenticate(with: credential)
              try await result.user.updateDisplayName(with: appleIDCredential)
              displayName = result.user.displayName ?? ""
            }
            catch {
              print("Error: \(error.localizedDescription)")
            }
          }
        }
        
      }
    }
  }

}
