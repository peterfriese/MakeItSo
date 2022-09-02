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
import Resolver
import os
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

public class ConfigurationService: ObservableObject {
  // MARK: - Dependencies
  @Injected var rc: RemoteConfig
  
  // MARK: - Publishers
  @Published var showDetailsButton: Bool = ConfigurationDefaults.showDetailsButtonValue
  @Published var todoCheckShape = ConfigurationDefaults.todoCheckShapeValue
    
  // MARK: - Private attributes
  private let logger = Logger(subsystem: "com.google.firebase.workshop.MakeItSo", category: "configuration")
    
  @MainActor
  func fetchConfigurationData() {
    Task {
      do {
        let status = try await rc.fetch()
        if status == .success {
          try await rc.activate()
          self.showDetailsButton = rc[ConfigurationDefaults.showDetailsButtonKey].boolValue
          self.todoCheckShape = try rc[ConfigurationDefaults.todoCheckShapeKey].decoded(asType: TodoCheckShape.self)
        }
        else {
          self.logger.debug("Could not fetch configuration data")
        }
      }
      catch {
        logger.error("Error when fetching remote configuration \(error.localizedDescription)")
      }
    }
  }
}
