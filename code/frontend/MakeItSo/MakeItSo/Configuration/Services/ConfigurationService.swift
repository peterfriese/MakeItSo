//
//  ConfigurationService.swift
//  MakeItSo
//
//  Created by Marina Coelho on 19.08.22.
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
import os
import FirebaseRemoteConfig

public class ConfigurationService: ObservableObject {
  private let logger = Logger(subsystem: "com.google.firebase.workshop.MakeItSo", category: "configuration")
    
  @Published var showDetailsButton: Bool = ConfigurationDefaults.showDetailsButtonValue
  @Published var todoCheckShape: String = ConfigurationDefaults.todoCheckShapeValue

  init() {
    RemoteConfig.remoteConfig().setDefaults(fromPlist: "RemoteConfigDefaults")
      
    #if DEBUG
      let settings = RemoteConfigSettings()
      settings.minimumFetchInterval = 0
      RemoteConfig.remoteConfig().configSettings = settings
    #endif
  }
    
  func fetchConfigurationData() async throws {
    let status = try await RemoteConfig.remoteConfig().fetch()
    if status == .success {
      try await RemoteConfig.remoteConfig().activate()
      DispatchQueue.main.async {
        self.showDetailsButton = RemoteConfig.remoteConfig().configValue(forKey: ConfigurationDefaults.showDetailsButtonKey).boolValue
        self.todoCheckShape = RemoteConfig.remoteConfig().configValue(forKey: ConfigurationDefaults.todoCheckShapeKey).stringValue ?? ConfigurationDefaults.todoCheckShapeValue
      }
    }
    else {
      self.logger.debug("Could not fetch configuration data")
    }
  }
}
