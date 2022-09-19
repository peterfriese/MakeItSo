//
//  ConfigurationDefaults.swift
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

struct ConfigurationDefaults {
  static let showDetailsButtonKey = "ShowDetailsButton"
  static let showDetailsButtonValue = true
    
  static let todoCheckShapeKey = "TodoCheckShape"
  static let todoCheckShapeValue = TodoCheckShape.circle
}

enum TodoCheckShape: String, Decodable {
  case circle
  case square
  
  func iconName(completed: Bool) -> String {
    let shape = self.rawValue
    return completed ? "checkmark.\(shape).fill" : shape
  }
}
