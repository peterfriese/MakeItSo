//
//  AuthenticationService.swift
//  MakeItSo
//
//  Created by Peter Friese on 23/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Firebase
import AuthenticationServices
import CryptoKit
import Resolver

class AuthenticationService: ObservableObject {
  
  @Published var user: User?
  
  @LazyInjected private var taskRepository: TaskRepository
  private var handle: AuthStateDidChangeListenerHandle?
  
  init() {
    registerStateListener()
  }
  
  func signIn() {
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously()
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print("Error when trying to sing out: \(error.localizedDescription)")
    }
  }
  
  private func registerStateListener() {
    if let handle = handle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
    self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      print("Sign in state has changed.")
      self.user = user
      
      if let user = user {
        let anonymous = user.isAnonymous ? "anonymously " : ""
        print("User signed in \(anonymous)with user ID \(user.uid).")
      }
      else {
        print("User signed out.")
        self.signIn()
      }
    }
  }
  
}

enum SignInState: String {
  case signIn
  case link
  case reauth
}

class SignInWithAppleCoordinator: NSObject {
  @Injected private var taskRepository: TaskRepository
  
  private weak var window: UIWindow!
  private var onSignedIn: ((User) -> Void)?

  private var currentNonce: String?
  
  init(window: UIWindow?) {
    self.window = window
  }
  
  private func appleIDRequest(withState: SignInState) -> ASAuthorizationAppleIDRequest {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.state = withState.rawValue
    
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
    
    return request
  }

  func signIn(onSignedIn: @escaping (User) -> Void) {
    self.onSignedIn = onSignedIn
    
    let request = appleIDRequest(withState: .signIn)

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
  
  func link(onSignedIn: @escaping (User) -> Void) {
    self.onSignedIn = onSignedIn
    
    let request = appleIDRequest(withState: .link)
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

}

extension SignInWithAppleCoordinator: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIdToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIdToken, encoding: .utf8) else {
        print("Unable to serialise token string from data: \(appleIdToken.debugDescription)")
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
        Auth.auth().signIn(with: credential) { (result, error) in
          if let error = error {
            print("Error authenticating: \(error.localizedDescription)")
            return
          }
          if let user = result?.user {
            if let onSignedIn = self.onSignedIn {
              onSignedIn(user)
            }
          }
        }
      case .link:
        if let currentUser = Auth.auth().currentUser {
          currentUser.link(with: credential) { (result, error) in
            if let error = error, (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
              print("The user you're signing in with has already been linked, signing in to the new user and migrating the anonymous users [\(currentUser.uid)] tasks.")
              
              // TODO: callback to UI and ask user if they would like to
              // (a) continue signing in to the selected account and (1) merge or (2) not merge data
              // or
              // (b) sign in using a different account (i.e. abort and start over)
              
              if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? OAuthCredential {
                print("Signing in using the updated credentials")
                Auth.auth().signIn(with: updatedCredential) { (result, error) in
                  if let user = result?.user {
                    let previousUserId = currentUser.uid
                    (self.taskRepository as? FirestoreTaskRepository)?.migrateTasks(fromUserId: previousUserId)
                    if let onSignedIn = self.onSignedIn {
                      onSignedIn(user)
                    }
                  }
                }
              }
            }
            else {
              if let user = result?.user {
                if let onSignedIn = self.onSignedIn {
                  onSignedIn(user)
                }
              }
            }
          }
        }
      case .reauth:
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
          if let error = error {
            print("Error authenticating: \(error.localizedDescription)")
            return
          }
          if let user = result?.user {
            if let onSignedIn = self.onSignedIn {
              onSignedIn(user)
            }
          }
        })
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Sign in with Apple errored: \(error.localizedDescription)")
  }
  
}

extension SignInWithAppleCoordinator: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.window
  }
}


// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
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

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
  }.joined()

  return hashString
}
