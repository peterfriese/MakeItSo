//
// RemindersRepository.swift
// MakeItSo
//
// Created by Peter Friese on 23.05.23.
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
import FirebaseFirestore
import FirebaseFirestoreSwift

public class RemindersRepository: ObservableObject {

  @Published
  var reminders = [Reminder]()

  func addReminder(_ reminder: Reminder) throws {
    try Firestore
      .firestore()
      .collection("reminders")
      .addDocument(from: reminder)
  }

}
