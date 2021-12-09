//
//	ReminderDetailsViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 23.11.21.
//  Contributing editor: Andrew Cowley on 8th Dec 2021
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
import SwiftUI //Needed for withOptionalAnimation

class ReminderDetailsViewModel: ObservableObject {
  @Published var reminder: Reminder
  private var original: Reminder
  
  init(reminder: Reminder) {
    self.reminder = reminder
    original = reminder
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
  
  var dueTime: Date {
    get {
      return dueDate
    }
    set {
      dueDate = newValue
    }
  }
  
  var hasDueDate: Bool {
    get {
      reminder.dueDate != nil
    }
    set {
      if newValue == true {
        reminder.dueDate = Date()
        setPickerState(.date)
      }
      else
      {
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
      }
      else
      {
        dueDate = dueDate.startOfDay()
        reminder.hasDueTime = false
        setPickerState(.none)
      }
    }
  }
  
  // We should never display the date picker and the time picker together
  // so define an enum to control single source of the truth for the
  // view state of the pickers (instead of two separate booleans which could both
  // mistakenly be set to true. Also allows each of the 6 transition animations to be controlled
  // precisely in one place.
  enum PickerState {
    case none, date, time
  }
  @Published var pickerState: PickerState = .none
  
  func setPickerState(_ newValue: PickerState) {
    // Dont animate if transitioning from state where date picker is shown
    if pickerState == .date {
      pickerState = newValue
    }
    else
    {
      // Animate transition if Accessibility setting allows.
      withOptionalAnimation {
        pickerState = newValue
      }
    }
  }
  
  // Toggle the display when a date value is pressed
  func datePressed() {
    pickerState = pickerState == .date ? .none : .date
  }
  // Toggle the display when a time value is pressed
  func timePressed() {
    pickerState = pickerState == .time ? .none : .time
  }

  func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
      return try body()
    }
    else
    {
      return try withAnimation(animation, body)
    }
  }
}

// The following Date extension functions are only currently used in this view model
// so for now, keep them here. If used elsewhere at a later date, they should be moved
// to their own extension file.
extension Date {
  func formattedRelativeToday() -> String {
    if !Calendar.autoupdatingCurrent.isDateInToday(self),
       !Calendar.autoupdatingCurrent.isDateInYesterday(self),
       !Calendar.autoupdatingCurrent.isDateInTomorrow(self) {
      return self.formatted(date: .complete, time: .omitted)
    }
    else
     {
      let formatStyle = Date.RelativeFormatStyle(
        presentation: .named,
        unitsStyle: .wide,
        capitalizationContext: .beginningOfSentence)
      return self.formatted(formatStyle)
     }
  }

  func nextHour(basedOn date: Date? = nil) -> Date? {
    var timeComponents = Calendar.current.dateComponents([.hour, .minute], from: date ?? self)
    let minute = timeComponents.minute ?? 0
    timeComponents.minute = 60 - minute
    return Calendar.current.date(byAdding: timeComponents, to: self)
  }

  func startOfDay() -> Date {
    Calendar.current.startOfDay(for: self)
  }
}
