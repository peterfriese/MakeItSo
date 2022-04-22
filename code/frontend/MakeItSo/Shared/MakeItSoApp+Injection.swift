//
//	MakeItSoApp+Injection.swift
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
import Resolver
import Firebase

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    // register Firebase services
    register { Firestore.firestore().enableLogging(on: true) }.scope(.application)
    
    // register application components
    register { AuthenticationService() }.scope(.application)
    register { RemindersRepository() }.scope(.application)
  }
}

extension Firestore {
  func enableLogging(on: Bool = true) -> Firestore {
    Self.enableLogging(on)
    return self
  }
}

