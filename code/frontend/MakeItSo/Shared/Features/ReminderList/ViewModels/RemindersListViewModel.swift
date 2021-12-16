//
//	RemindersListViewModel.swift
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
import Combine
import SwiftUI
import Resolver

class RemindersListViewModel: ObservableObject {
  @Published var remindersRepository: ReminderRepository
  
  @Published var reminders: [Reminder]
  @Published var selectedReminder: Reminder?
  @Published var focusedReminder: Focusable?
  var previousFocusedReminder: Focusable?
  
  private var cancellables = Set<AnyCancellable>()
  
  init(reminders: [Reminder]) {
    self.reminders = reminders
    
    remindersRepository = Resolver.resolve()
    remindersRepository.subscribe()
    remindersRepository.$reminders
      .assign(to: &$reminders)
    
    // This is the beginning of some magic Firestore sauce
    //    $reminders.sink { newValue in
    //      self.dump(newValue)
    //      self.performUpdates(newValue)
    //    }
    //    .store(in: &cancellables)
    
    // the following pipeline removes empty reminder when the respecive row in the list view loses focus
    $focusedReminder
      .removeDuplicates()
      .compactMap { focusedReminder -> Int? in
        defer { self.previousFocusedReminder = focusedReminder }
        
        guard focusedReminder != nil else { return nil }
        guard case .row(let previousId) = self.previousFocusedReminder else { return nil }
        guard let previousIndex = self.reminders.firstIndex(where: { $0.id == previousId } ) else { return nil }
        guard self.reminders[previousIndex].title.isEmpty else { return nil }
        
        return previousIndex
      }
      .delay(for: 0.01, scheduler: RunLoop.main) // <-- this helps reduce the visual jank
      .sink { index in
        self.reminders.remove(at: index)
      }
      .store(in: &cancellables)

// This is the unoptimised version. It results in visual jank.
//    $focusedReminder
//      .removeDuplicates()
//      .sink { focusedReminder in
//        if case .row(let previousId) = self.previousFocusedReminder, case .row(let currentId) = focusedReminder {
//          print("Previous: \(previousId)")
//          print("Current: \(currentId)")
//          if let previousIndex = self.reminders.firstIndex(where: { $0.id == previousId } ) {
//            if self.remindersa[previousIndex].title.isEmpty {
//              self.reminders.remove(at: previousIndex)
//            }
//          }
//        }
//        self.previousFocusedReminder = focusedReminder
//      }
//      .store(in: &cancellables)
  }
  
  func createNewReminder() {
    let newReminder = Reminder(title: "")

    // if any row is focused, insert the new reminder after the focused row
    if case .row(let id) = focusedReminder {
      if let index = reminders.firstIndex(where: { $0.id == id } ) {
        
        // If the currently selected reminder is empty, unfocus it.
        // This will kick off the pipeline that removes empty reminders.
        let currentReminder = reminders[index]
        guard !currentReminder.title.isEmpty else {
          focusedReminder = Focusable.none
          return
        }
        
        reminders.insert(newReminder, at: index + 1)
      }
    }
    // no row focused: append at the end of the list
    else {
      reminders.append(newReminder)
    }
    remindersRepository.addReminder(newReminder)
    
    // focus the new reminder
    if let reminderId = newReminder.id {
      focusedReminder = .row(id: reminderId)
    }
  }
  
  func deleteReminder(_ reminder: Reminder) {
    Just(reminder)
      .delay(for: .seconds(0.25), scheduler: RunLoop.main)
      .sink { reminder in
        if let index = self.reminders.firstIndex(of: reminder) {
          self.reminders.remove(at: index)
          self.remindersRepository.removeReminder(reminder)
        }
      }
      .store(in: &cancellables)
  }
  
  func updateReminder(_ reminder: Reminder) {
    if let index = reminders.firstIndex(where: { $0.id == reminder.id} ) {
      reminders[index] = reminder
      remindersRepository.updateReminder(reminder)
    }
  }
  
  func flagReminder(_ reminder: Reminder) {
    if let index = reminders.firstIndex(of: reminder) {
      reminders[index].flagged.toggle()
    }
  }
  
}


extension RemindersListViewModel {
  func dump(_ newValue: [Reminder]) {
    print("--->>>")
    print("Object value")
    print(self.reminders)
    print("Closure value")
    print(newValue)
    print("<<<---")
  }
  
  func performUpdates(_ newValue: [Reminder]) {
    let difference = newValue.difference(from: self.reminders)
    let moves = difference.inferringMoves()
    for update in moves {
      switch update {
      case .remove(let offset, let letter, let move):
        print("Removed \(letter) at idx \(offset) and moved to \(String(describing: move))")
      case .insert(let offset, let letter, let move):
        print("Inserted \(letter) at idx \(offset) from \(String(describing: move))")
      }
    }
  }
}
