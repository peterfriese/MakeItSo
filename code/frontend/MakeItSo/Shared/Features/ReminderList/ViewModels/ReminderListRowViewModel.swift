//
//	ReminderListRowViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 30.11.21.
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

import SwiftUI

class ReminderListRowViewModel: ObservableObject {
  @Binding var reminder: Reminder
  
  init(reminder: Binding<Reminder>) {
    self._reminder = reminder
  }
  
  var priorityAdornment: String {
    String(repeating: "!", count: (reminder.priority.index ?? 0))
  }
  
  var hasDueDate: Bool {
    reminder.dueDate != nil
  }
  
  var hasDueTime: Bool {
    reminder.hasDueTime
  }
  
  var dueDate: Date {
    reminder.dueDate ?? Date()
  }
  
  var formattedDueDate: String {
    guard let dueDate = reminder.dueDate else { return "" }
    return dueDate.formattedRelativeToday()
  }
}
