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
import Combine

extension Date {
  func formattedRelativeToday() -> String {
    if Calendar.autoupdatingCurrent.isDateInToday(self)
        || Calendar.autoupdatingCurrent.isDateInYesterday(self)
        || Calendar.autoupdatingCurrent.isDateInTomorrow(self) {
      
      let formatStyle = Date.RelativeFormatStyle(
        presentation: .named,
        unitsStyle: .wide,
        capitalizationContext: .beginningOfSentence)
      
      return self.formatted(formatStyle)
    }
    else {
      return self.formatted(date: .complete, time: .omitted)
    }
  }
  
  func nearestHour() -> Date? {
    var components = NSCalendar.current.dateComponents([.minute], from: self)
    let minute = components.minute ?? 0
    components.minute = minute >= 30 ? 60 - minute : -minute
    return Calendar.current.date(byAdding: components, to: self)
  }
  
  func nextHour(basedOn date: Date? = nil) -> Date? {
    let other = date ?? self
    
    var timeComponents = Calendar.current.dateComponents([.hour, .minute], from: other)
    let minute = timeComponents.minute ?? 0
    timeComponents.minute = minute >= 0 ? 60 : 0
    
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)

    let newDateComponents = DateComponents(calendar: Calendar.current,
                                           year: dateComponents.year,
                                           month: dateComponents.month,
                                           day: dateComponents.day,
                                           hour: timeComponents.hour,
                                           minute: timeComponents.minute)
    
    return Calendar.current.date(from: newDateComponents)
  }
  
  func startOfDay() -> Date {
    Calendar.current.startOfDay(for: self)
  }
}


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
        isShowingDatePicker = true
      }
      else {
        hasDueTime = false
        reminder.dueDate = nil
        isShowingDatePicker = false
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
        isShowingTimePicker = true
      }
      else {
        dueDate = dueDate.startOfDay()
        reminder.hasDueTime = false
        isShowingTimePicker = false
      }
    }
  }
  
  @Published var isShowingDatePicker: Bool = false
  @Published var isShowingTimePicker: Bool = false
  
  func toggleTimePicker() {
    isShowingTimePicker.toggle()
    isShowingDatePicker = false
  }
  
  func toggleDatePicker() {
    isShowingDatePicker.toggle()
    isShowingTimePicker = false
  }

}
