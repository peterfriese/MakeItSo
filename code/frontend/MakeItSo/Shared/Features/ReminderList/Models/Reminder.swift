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

enum Priority: String, Pickable, Codable {
   case none, low, medium, high
}
extension Priority: Comparable {
   static func < (lhs: Priority, rhs: Priority) -> Bool {
      lhs.index < rhs.index
   }

   var index: Int {
      switch self {
         case .none: return 0
         case .low: return 1
         case .medium: return 2
         case .high: return 3
      }
   }
}

enum Repeat: String, Pickable, Codable {
   case never, daily, weekdays, weekends, weekly, fortnightly, monthly, every3months, every6months, yearly

   var description: String {
      switch self {
         case .every3months: return "Every 3 months"
         case .every6months: return "Every 6 months"
         default:  return self.rawValue.capitalized
      }
   }
}

struct Tag {
   var title: String
}

struct Location {
}

struct Reminder {
   var id: String = UUID().uuidString
   var title: String
   var notes: String?
   var url: String?

   var dueDate: Date?
   var hasDueTime: Bool = false

   var repeatFrequency: Repeat = .never
   var repeatEndDate: Date?

   var tags: [Tag]?

   var location: Location?

   // TODO: when messaging

   var flagged: Bool = false

   var priority: Priority = .none
   // TODO: parent list

   // TODO: subtasks (it's interesting to note that these are actually
   //       called "subtasks" in the UI of Apple's Reminders app!

   // TOOD: images

   var completed: Bool = false
   var order: Int = 0
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
      Reminder(title: "???")
      //    Reminder(title: "PROFIT!!")
   ]
}
