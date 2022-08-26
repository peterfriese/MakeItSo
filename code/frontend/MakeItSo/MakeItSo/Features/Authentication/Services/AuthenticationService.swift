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
import AuthenticationServices
import CryptoKit
import Resolver
import FirebaseCore
import FirebaseAuth
import Combine

public class AuthenticationService: ObservableObject {
  private let logger = Logger(subsystem: "com.google.firebase.quickstart.MakeItSo", category: "authentication")
  
  @Published var user: User?
  @Published var displayName: String = ""
  @Published var authenticationState: AuthenticationState = .unauthenticated
  
  private var authStateHandler: AuthStateDidChangeListenerHandle?
  private var currentNonce: String?
  
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

// MARK: - Sign in with Email and Password

extension AuthenticationService {
  
  /// Signs in using an email address and a password.
  /// - Parameters:
  ///   - email: The user's email
  ///   - password: The user's password
  func signIn(withEmail email: String, password: String) async throws {
    try await Auth.auth().signIn(withEmail: email, password: password)
  }

  /// Signs up using an email address and a password. If the current user is an anonymous user,
  /// upgrades the anonymous user to a full account by linking it using the given email and password.
  /// - Parameters:
  ///   - email: The user's email
  ///   - password: The user's password
  func signUp(withEmail email: String, password: String) async throws {
    if let user, user.isAnonymous {
      try await link(withEmail: email, password: password)
    }
    else {
      try await Auth.auth().createUser(withEmail: email, password: password)
    }
  }
  
  func link(withEmail email: String, password: String) async throws {
    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
    let result = try await user?.link(with: credential)
    await MainActor.run {
      self.user = result?.user
    }
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


