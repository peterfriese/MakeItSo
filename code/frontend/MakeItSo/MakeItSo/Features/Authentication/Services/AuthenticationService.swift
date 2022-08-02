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
import Firebase
import os
import AuthenticationServices
import CryptoKit
import Resolver

public class AuthenticationService: ObservableObject {
  private let logger = Logger(subsystem: "com.google.firebase.quickstart.MakeItSo", category: "authentication")
  
  @Published var user: User?
  @Published var displayName: String = ""
  @Published var authenticationState: AuthenticationState = .unauthenticated
  
  private var authStateHandler: AuthStateDidChangeListenerHandle?
  private var currentNonce: String?
  
  init() {
    registerAuthStateHandler()
    verifySignInWithAppleAuthenticationState()
    registerCredentialRevocationListener()
  }
  
  private func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.authenticationState = user == nil ? .unauthenticated : .authenticated
        self.displayName = user?.displayName ?? user?.email ?? ""
        
        if let user = user {
          if user.isAnonymous {
            self.logger.debug("User signed in anonymously with user ID \(user.uid).")
          }
          else {
            self.logger.debug("User signed in with user ID \(user.uid). Email: \(user.email ?? "(empty)"), display name: [\(user.displayName ?? "(empty)")]")
          }
        }
        else {
          self.logger.debug("User signed out.")
          self.signIn()
        }
      }
    }
  }
}

// MARK: - Generic account operations

extension AuthenticationService {
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

// MARK: - Sign in with Email and Password

extension AuthenticationService {
  func signIn(withEmail email: String, password: String) async throws {
    try await Auth.auth().signIn(withEmail: email, password: password)
  }

  func signUp(withEmail email: String, password: String) async throws {
    try await Auth.auth().createUser(withEmail: email, password: password)
  }
  
  func link(withEmail email: String, password: String) async throws {
    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
    try await user?.link(with: credential)
  }
}

// MARK: - Sign in with Apple

extension AuthenticationService {
  func verifySignInWithAppleAuthenticationState() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let providerData = Auth.auth().currentUser?.providerData
    if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
      Task {
        do {
          let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
          switch credentialState {
          case .authorized:
            break // The Apple ID credential is valid.
          case .revoked, .notFound:
            // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
            try self.signOut()
          default:
            break
          }
        }
        catch {
        }
      }
    }
  }
  
  func registerCredentialRevocationListener() {
    NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
                                           object: nil,
                                           queue: nil) { [weak self] notification in
      do {
        try self?.signOut()
      }
      catch {
        print(error)
      }
    }
  }
}

extension ASAuthorizationAppleIDCredential {
  func displayName() -> String {
    return [self.fullName?.givenName, self.fullName?.familyName]
      .compactMap { $0 }
      .joined(separator: " ")
  }
}

extension User {
  func updateDisplayName(with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async throws {
    if let currentDisplayName = Auth.auth().currentUser?.displayName, currentDisplayName.isEmpty {
      let changeRequest = self.createProfileChangeRequest()
      changeRequest.displayName = appleIDCredential.displayName()
      try await changeRequest.commitChanges()
    }
  }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
public func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] =
  Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}

public func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()

  return hashString
}


