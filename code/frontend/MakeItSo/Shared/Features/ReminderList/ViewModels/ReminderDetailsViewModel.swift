//
//	ReminderDetailsViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 23.11.21.
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

// We should never display the date picker and the time picker together
// so define an enum to control view state of the pickers
enum PickerState {
   case none, date, time
}

class ReminderDetailsViewModel: ObservableObject {
   @Published var reminder: Reminder
   private var original: Reminder
   @Published var pickerState: PickerState = .none

   init(reminder: Reminder) {
      self.reminder = reminder
      original = reminder
      // sync Picker display to date/time in reminder
      //      if reminder.hasDueTime {
      //         pickerState = .time
      //      } else if reminder.dueDate != nil {
      //         pickerState = .date
      //      }
   }

   var isModified: Bool {
      original != reminder
   }

   // The `notes` attribute on the Reminder model is optional.
   // Using this approach allows us to bind the notes to SwiftUI
   // views.
   var notes: String {
      get {
         reminder.notes ?? ""
      }
      set {
         reminder.notes = newValue
      }
   }

   var url: String {
      get {
         reminder.url ?? ""
      }
      set {
         reminder.url = newValue
      }
   }

   var dueDate: Date {
      get {
         return reminder.dueDate ?? Date()
      }
      set {
         reminder.dueDate = newValue
      }
   }

   var tags: [Tag] {
      get {
         return reminder.tags ?? []
      }
      set {
         reminder.tags = newValue
      }
   }

   var repeatFrequency: Repeat {
      get { reminder.repeatFrequency }
      set { reminder.repeatFrequency = newValue }
   }
   var repeatEndDate: Date {
      get { reminder.repeatEndDate ?? Date() }
      set { reminder.repeatEndDate = newValue }
   }

   //   var dueTime: Date {
   //      get {
   //         return dueDate
   //      }
   //      set {
   //         dueDate = newValue
   //      }
   //   }
   //
   var hasDueDate: Bool {
      get {
         reminder.dueDate != nil
      }
      set {
         if newValue == true {
            reminder.dueDate = Date()
            setPickerState(.date)
         } else {
            reminder.dueDate = nil
            reminder.hasDueTime = false
            setPickerState(.none)
         }
      }
   }

   var hasDueTime: Bool {
      get {
         reminder.hasDueTime
      }
      set {
         if newValue == true {
            guard let nearestHour = dueDate.nextHour(basedOn: Date()) else { return }
            dueDate = nearestHour
            reminder.hasDueTime = true
            setPickerState(.time)
         } else {
            dueDate = dueDate.startOfDay()
            reminder.hasDueTime = false
            setPickerState(.none)
         }
      }
   }

   /*==========Functions: date/time presses on labels ======================*/

   func setPickerState(_ newvalue: PickerState) {
      withOptionalAnimation {
         pickerState = newvalue
      }
   }

   // Toggle the display when a date value is pressed
   func datePressed() {
      if pickerState == .date {
         setPickerState(.none)
      } else {
         setPickerState(.date)
      }
   }

   // Toggle the display when a time value is pressed
   func timePressed() {
      if pickerState == .time {
         setPickerState(.none)
      } else {
         setPickerState(.time)
      }
   }
}
