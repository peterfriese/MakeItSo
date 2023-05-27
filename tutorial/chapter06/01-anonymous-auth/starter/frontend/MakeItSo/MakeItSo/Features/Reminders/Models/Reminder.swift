//
// Reminder.swift
// MakeItSo
//
// Created by Peter Friese on 01.03.23.
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

struct Reminder: Identifiable, Codable {
  @DocumentID
  var id: String?
  var title: String
  var isCompleted = false
  var userId: String? = nil
}

extension Reminder {
  static let collectionName = "reminders"
}

extension Reminder {
  static let samples = [
    Reminder(title: "Build sample app", isCompleted: true),
    Reminder(title: "Create tutorial"),
    Reminder(title: "???"),
    Reminder(title: "PROFIT!"),
  ]
}
