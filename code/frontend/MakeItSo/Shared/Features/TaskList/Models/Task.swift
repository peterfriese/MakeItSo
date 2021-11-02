//
//	Task.swift
//  MakeItSo
//
//  Created by Peter Friese on 26.10.21.
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

enum Priority {
  case none
  case low
  case medium
  case high
}

struct Tag {
  var title: String
}

struct Location {
}

struct Task {
  var id: String = UUID().uuidString
  var title: String
  var notes: String = ""
  var url: String = ""
  
  var dueDate: Date?
  var dueTime: Date?

  var tags: [Tag]?

  var location: Location?

  // TODO: when messaging

  var flagged: Bool = false

  var priority: Priority = .none
  // TODO: parent list

  // TODO: subtasks

  // TOOD: images

  var completed: Bool = false
  var order: Int = 0
}

extension Task {
  var hasDueDate: Bool {
    get {
      dueDate != nil
    }
    set {
      if newValue == true {
        dueDate = Date()
      }
      else {
        dueDate = nil
      }
    }
  }
  
  var hasDueTime: Bool {
    get {
      dueTime != nil
    }
    set {
      if newValue == true {
        dueTime = Date()
      }
      else {
        dueTime = nil
      }
    }
  }

}

extension Priority: Codable, Equatable {
}

extension Tag: Codable, Equatable {
}

extension Location: Codable, Equatable {
}

extension Task: Codable, Identifiable, Equatable {
}

// so we can use Array.difference
extension Task: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Task {
  static let samples = [
    Task(title: "Build sample app"),
    Task(title: "Tweet about surprising findings", flagged: true),
    Task(title: "Write newsletter"),
    Task(title: "Run YouTube video series"),
    Task(title: "???"),
//    Task(title: "PROFIT!!")
  ]
}
