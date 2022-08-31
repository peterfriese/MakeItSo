//
//  MakeItSoApp.swift
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

import SwiftUI
import Resolver
import FirebaseCore
import AuthenticationServices
import os

class AppDelegate: NSObject, UIApplicationDelegate {
  @LazyInjected var authenticationService: AuthenticationService
  @LazyInjected var configurationService: ConfigurationService
    
  let logger = Logger(subsystem: "com.google.firebase.workshop.MakeItSo", category: "persistence")
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    authenticationService.signIn()
      
    Task {
      do {
        try await configurationService.fetchConfigurationData()
      }
      catch {
        logger.debug("Could not fetch configuration data")
      }
    }

    return true
  }
}

@main
struct MakeItSoApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @LazyInjected var authenticationService: AuthenticationService
  
  var body: some Scene {
    WindowGroup {
      TodosListView()
    }
  }
}
