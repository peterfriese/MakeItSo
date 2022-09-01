//
//  MakeItSo+Injection.swift
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
import Resolver
import Firebase
import FirebaseRemoteConfig

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    // register Firebase services
    register { Firestore.firestore().enableLogging(on: true) }.scope(.application)
    register { RemoteConfig.remoteConfig().configure() }.scope(.application)
    
    // register application components
    register { AuthenticationService() }.scope(.application)
    register { ConfigurationService() }.scope(.application)
    register { TodosRepository() }.scope(.application)
  }
}

extension Firestore {
  func enableLogging(on: Bool = true) -> Firestore {
    Self.enableLogging(on)
    return self
  }
}

extension RemoteConfig {
  func configure() -> RemoteConfig {
    self.setDefaults(fromPlist: "RemoteConfigDefaults")
        
    #if DEBUG
      let settings = RemoteConfigSettings()
      settings.minimumFetchInterval = 0
      self.configSettings = settings
    #endif
        
    return self
  }
}

