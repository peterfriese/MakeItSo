//
//	AuthenticationService.swift
//  MakeItSo
//
//  Created by Peter Friese on 16.12.21.
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
import Firebase
import os
import AuthenticationServices
import CryptoKit
import Resolver

public class AuthenticationService: ObservableObject {
  private let logger = Logger(subsystem: "dev.peterfriese.MakeItSo", category: "authentication")
  
  @Published public var user: User?
  
  private var handle: AuthStateDidChangeListenerHandle?
  
  public init() {
    setupKeychainSharing()
    registerStateListener()
  }
  
  public func signIn() {
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously()
    }
  }
  
  public func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print("error when trying to sign out: \(error.localizedDescription)")
    }
  }
  
  func updateDisplayName(displayName: String, completionHandler: @escaping (Result<User, Error>) -> Void) {
    if let user = Auth.auth().currentUser {
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = displayName
      changeRequest.commitChanges { error in
        if let error = error {
          completionHandler(.failure(error))
        }
        else {
          if let updatedUser = Auth.auth().currentUser {
            print("Successfully updated display name for user [\(user.uid)] to [\(updatedUser.displayName ?? "(empty)")]")
            // force update the local user to trigger the publisher
            self.user = updatedUser
            completionHandler(.success(updatedUser))
          }
        }
      }
    }
  }
  
  private var accessGroup: String {
    get {
      let info = KeyChainAccessGroupHelper.getAccessGroupInfo()
      let prefix = info?.prefix ?? "unknown"
      return prefix + "." + (Bundle.main.bundleIdentifier ?? "unknown")
    }
  }
  
  private func setupKeychainSharing() {
    do {
      let auth = Auth.auth()
      auth.shareAuthStateAcrossDevices = true
      try auth.useUserAccessGroup(accessGroup)
    }
    catch let error as NSError {
      print("Error changing user access group: %@", error)
    }
  }
  
  private func registerStateListener() {
    if handle == nil {
      handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
        self.user = user
        
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
      })
    }
  }
}
