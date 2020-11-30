//
//  MakeItSoApp.swift
//  MakeItSo
//
//  Created by Peter Friese on 30/11/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

import Resolver
import Firebase

@main
struct MakeItSoApp: App {
  
  @LazyInjected var authenticationService: AuthenticationService
  
  init() {
    FirebaseApp.configure()
    authenticationService.signIn()
  }
  
  var body: some Scene {
    WindowGroup {
      TaskListView()
    }
  }
}
