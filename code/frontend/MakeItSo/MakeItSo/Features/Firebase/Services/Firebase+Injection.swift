//
// Firebase+Injection.swift
// MakeItSo
//
// Created by Peter Friese on 19.05.23.
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
import Factory
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

extension Container {
  static var logger = Container.shared.logger("configuration")

  /// Determines whether to use the Firebase Local Emulator Suite.
  /// To use the local emulator, go to the active scheme, and add `-useEmulator YES`
  /// to the _Arguments Passed On Launch_ section.
  public var useEmulator: Factory<Bool> {
    self {
      let value =  UserDefaults.standard.bool(forKey: "useEmulator")
      Self.logger.log("Using the emulator: \(value == true ? "YES" : "NO")")
      return value
    }.singleton
  }

  public var firestore: Factory<Firestore> {
    self {
      var environment = ""
      if Container.shared.useEmulator() {
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        environment = "to use the local emulator on \(settings.host)"

        Firestore.firestore().settings = settings
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)

      }
      else {
        environment = "to use the Firebase backend"
      }

      Firestore.enableLogging(false)

      Self.logger.log("Configuring Cloud Firestore \(environment).")
      return Firestore.firestore()
    }.singleton
  }


}


