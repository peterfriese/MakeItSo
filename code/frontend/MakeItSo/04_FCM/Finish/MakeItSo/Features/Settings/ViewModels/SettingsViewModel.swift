//
//  SettingsViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 27.07.22.
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
import FirebaseAuth
import Resolver

class SettingsViewModel: ObservableObject {
  @LazyInjected private var authenticationService: AuthenticationService
  
  @Published var user: User?
  @Published var isAnonymous = true
  @Published var displayName: String = ""
  @Published var authenticationState: AuthenticationState = .unauthenticated
  
  init() {
    authenticationService
      .$user
      .assign(to: &$user)
    
    $user
      .compactMap { $0?.isAnonymous }
      .assign(to: &$isAnonymous)
    
    authenticationService
      .$displayName
      .assign(to: &$displayName)
    
    authenticationService
      .$authenticationState
      .assign(to: &$authenticationState)
  }
  
  func signOut() {
    do {
      try authenticationService.signOut()
    }
    catch {
      print(error)
    }
  }
}
