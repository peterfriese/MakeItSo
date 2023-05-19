//
// AuthenticationService.swift
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
import Combine
import FirebaseCore
import FirebaseAuth

// For Sign in with Apple
import AuthenticationServices
import CryptoKit

// For Google Sign-In
import GoogleSignIn

public class AuthenticationService {
  @Published var user: User?
  @Published var errorMessage = ""
  @Published var authenticationState: AuthenticationState = .unauthenticated
  
  private var authStateHandler: AuthStateDidChangeListenerHandle?
  private var currentNonce: String?
  
  init() {
    registerAuthStateHandler()
    verifySignInWithAppleAuthenticationState()
    
    signInAnonymously()
  }
  
  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.authenticationState = user == nil ? .unauthenticated : .authenticated
      }
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      signInAnonymously()
    }
    catch {
      print(error)
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
          print(error.localizedDescription)
          errorMessage = error.localizedDescription
        }
      }
    }
    else {
      print("Someone is signed in")
      if let user = Auth.auth().currentUser {
        print(user.uid)
      }
    }
  }
}

// MARK: - Email and Password Authentication

extension AuthenticationService {
  func linkWithEmailPassword(email: String, password: String) async -> Bool {
    authenticationState = .authenticating
    do {
      let credential = EmailAuthProvider.credential(withEmail: email, password: password)
      if let user {
        let result = try await user.link(with: credential)
        self.user = result.user
        authenticationState = .authenticated
        return true
      }
      else {
        fatalError("No user was signed in. This should not happen.")
      }
    }
    catch  {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }
  
  func signInWithEmailPassword(email: String, password: String) async -> Bool {
    authenticationState = .authenticating
    do {
      try await Auth.auth().signIn(withEmail: email, password: password)
      return true
    }
    catch  {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }
  
  func signUpWithEmailPassword(email: String, password: String) async -> Bool {
    authenticationState = .authenticating
    do  {
      try await Auth.auth().createUser(withEmail: email, password: password)
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

// MARK: - Google Sign-In

enum AuthenticationError: Error {
  case tokenError(message: String)
}

extension AuthenticationService {
  func signInWithGoogle() async -> Bool {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      fatalError("No client ID found in Firebase configuration")
    }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = await windowScene.windows.first,
          let rootViewController = await window.rootViewController else {
      print("There is no root view controller!")
      return false
    }
    
    do {
      let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
      
      let user = userAuthentication.user
      guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
      let accessToken = user.accessToken
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                     accessToken: accessToken.tokenString)
      
      let result = try await Auth.auth().signIn(with: credential)
      let firebaseUser = result.user
      print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
      return true
    }
    catch {
      print(error.localizedDescription)
      self.errorMessage = error.localizedDescription
      return false
    }
  }
}

// MARK: - Sign in with Apple

extension AuthenticationService {
  
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
  }
  
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async -> Bool {
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
          print("Unable to fetdch identify token.")
          return false
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
          return false
        }
        
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)
        
        do {
          try await Auth.auth().signIn(with: credential)
          return true
        }
        catch {
          print("Error authenticating: \(error.localizedDescription)")
          return false
        }
      }
    }
    return false
  }
  
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
            self.signOut()
          default:
            break
          }
        }
        catch {
        }
      }
    }
  }
  
}

extension ASAuthorizationAppleIDCredential {
  func displayName() -> String {
    return [self.fullName?.givenName, self.fullName?.familyName]
      .compactMap( {$0})
      .joined(separator: " ")
  }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
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
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
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

private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()
  
  return hashString
}


private func dumpUser(_ user: User) {
  print(user.email)
  print(user.isEmailVerified)
  print(user.providerID)
}

