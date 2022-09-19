//
//  AuthenticationService+SignInWithApple.swift
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
import AuthenticationServices
import CryptoKit
import FirebaseAuth

// MARK: - Sign in with Apple

enum AuthenticationStrategy: String {
  case signIn
  case link
  case reauth
  
  func handleAuthentication(with credential: OAuthCredential) async throws -> AuthDataResult {
    switch self {
    case .signIn:
      return try await Auth.auth().signIn(with: credential)
    case .link:
      guard let currentUser = Auth.auth().currentUser else { fatalError() }
      do {
        return try await currentUser.link(with: credential)
      }
      catch {
        if (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
          print("The user you're signing in with has already been linked, signing in instead.")
          guard let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential else { fatalError() }
          return try await Auth.auth().signIn(with: updatedCredential)
        }
        else {
          fatalError()
        }
      }
    case .reauth:
      guard let currentUser = Auth.auth().currentUser else { fatalError() }
      return try await currentUser.reauthenticate(with: credential)
    }
  }
}

extension AuthenticationService {
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest, withStrategy strategy: AuthenticationStrategy = .signIn) {

  }
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) throws {
    if case .failure(let failure) = result {
      throw failure
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
        guard let stateRaw = appleIDCredential.state, let strategy = AuthenticationStrategy(rawValue: stateRaw) else {
          print("Invalid state: request must be started with one of the SignInStates")
          return
        }
        
        // Create credential and call handleAuthentication
        
      }
    }
  }
  
}

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


