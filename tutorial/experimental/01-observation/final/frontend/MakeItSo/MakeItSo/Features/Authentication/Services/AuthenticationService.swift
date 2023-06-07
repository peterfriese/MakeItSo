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
import Observation
import Factory
import FirebaseAuth
import AuthenticationServices

@Observable
public class AuthenticationService {
  @ObservationIgnored
  @Injected(\.auth) private var auth

  let logger = Container.shared.logger("authentication")

  var user: User? = nil

  var errorMessage = ""

  private var authStateHandler: AuthStateDidChangeListenerHandle? = nil
  private var currentNonce: String? = nil

  init() {
    registerAuthStateHandler()

    signInAnonymously()
  }

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = auth.addStateDidChangeListener { auth, user in
        self.user = user
      }
    }
  }

  func signOut() {
    do {
      try auth.signOut()
      signInAnonymously()
    }
    catch {
      logger.error("Error while trying to sign out: \(error.localizedDescription)")
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
    if auth.currentUser == nil {
      logger.info("Nobody is signed in. Trying to sign in anonymously.")
      Task {
        do {
          try await auth.signInAnonymously()
          errorMessage = ""
        }
        catch {
          logger.error("Error when trying to sign in anonymously: \(error.localizedDescription)")
          errorMessage = error.localizedDescription
        }
      }
    }
    else {
      if let user = auth.currentUser {
        logger.info("Someone is signed in with \(user.providerID) and user ID \(user.uid)")
      }
    }
  }
}

// MARK: - Sign in with Apple

extension AuthenticationService {
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    do {
      let nonce = try CryptoUtils.randomNonceString()
      currentNonce = nonce
      request.nonce = CryptoUtils.sha256(nonce)
    }
    catch {
      logger.error("Error when creating a nonce: \(error.localizedDescription)")
    }
  }

  @MainActor
  func handleSignInWithAppleCompletion(withAccountLinking: Bool = false, _ result: Result<ASAuthorization, Error>) async -> Bool {
    if case .failure(let failure) = result {
      errorMessage = failure.localizedDescription
      return false
    }
    else if case .success(let authorization) = result {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: a login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          logger.error("Unable to fetch identify token.")
          return false
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          logger.error("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
          return false
        }

        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)

        do {
          if withAccountLinking {
            let authResult = try await user?.link(with: credential)
            self.user = authResult?.user
          }
          else {
            try await auth.signIn(with: credential)
          }
          return true
        }
        catch {
          logger.error("Error authenticating: \(error.localizedDescription)")
          return false
        }
      }
    }
    return false
  }
  
}
