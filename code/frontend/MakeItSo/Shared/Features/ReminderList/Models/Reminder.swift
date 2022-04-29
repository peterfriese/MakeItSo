//
//	Reminder.swift
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
import FirebaseFirestoreSwift

enum Priority: String {
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

struct Reminder {
  /// We need the Firestore document ID so we can update / delete the document
  @DocumentID var docId: String?
  
  /// The `id` is required to make the `Reminder` identifiable. We also need to persist this, otherwise
  /// it would get lost when round-tripping to Firestore, which would result in the item losing focus.
  var id: String? = UUID().uuidString
  var title: String
  var notes: String?
  var url: String?
  
  var dueDate: Date?
  var hasDueTime: Bool = false

  var tags: [Tag]?

  var location: Location?

  // TODO: when messaging

  var flagged: Bool = false

  var priority: Priority = .none
  // TODO: parent list

  // TODO: subtasks (it's interesting to note that these are actually called "subtasks" in the UI of Apple's Reminders app!

  // TOOD: images

  var completed: Bool = false
  var order: Int = 0
  
  var userId: String?
}

extension Priority: Codable, Equatable, Identifiable {
  var id: Priority { self }
}

extension Priority: Comparable {
  static func < (lhs: Priority, rhs: Priority) -> Bool {
    guard let l = lhs.index, let r = rhs.index else { return false }
    return l < r
  }
}

// Conforming Priority to CaseIterable allows us to use it inside a `Picker` view
extension Priority: CaseIterable { }

// This allows us to determine the index of a case inside an enum.
// For example, this is used to compute the representation of a
// task priority (!, !!, !!!, or en empty string for "no priority").
extension CaseIterable where Self: Equatable {
  var index: Self.AllCases.Index? {
    return Self.allCases.firstIndex { self == $0 }
  }
}

extension Tag: Codable, Equatable {
}

extension Location: Codable, Equatable {
}

extension Reminder: Codable, Identifiable, Equatable {
}

// so we can use Array.difference
extension Reminder: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Reminder {
  static let samples = [
    Reminder(title: "Build sample app", dueDate: Date.now, priority: .high),
    Reminder(title: "Tweet about surprising findings", dueDate: Date.now, flagged: true),
    Reminder(title: "Write newsletter", priority: .medium),
    Reminder(title: "Run YouTube video series"),
    Reminder(title: "???"),
//    Reminder(title: "PROFIT!!")
  ]
}
