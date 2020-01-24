//
//  AuthenticationService.swift
//  MakeItSo
//
//  Created by Peter Friese on 23/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationService: ObservableObject {
  
  @Published var user: User?
  
  func signIn() {
    registerStateListener()
    Auth.auth().signInAnonymously()
  }
  
  private func registerStateListener() {
    Auth.auth().addStateDidChangeListener { (auth, user) in
      print("Sign in state has changed.")
      self.user = user
      
      if let user = user {
        let anonymous = user.isAnonymous ? "anonymously " : ""
        print("User signed in \(anonymous)with user ID \(user.uid).")
      }
      else {
        print("User signed out.")
      }
    }
  }
  
}
