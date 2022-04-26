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

enum SortingMode {
  case manual
  case byDeadline
  case byCreationDate
  case byPriority
  case byTitle
  
  func sorted(lhs: Reminder, rhs: Reminder) -> Bool {
    return lhs.order < rhs.order
  }
}

extension Array where Element == Reminder {
  func computeOrder(for reminder: Reminder) -> Int {
    let index = self.endIndex == 0 ? 0 : self.endIndex - 1
    return self.computeOrder(for: reminder, after: index)
  }
  
  func computeOrder(for reminder: Reminder, after index: Int) -> Int {
    guard self.count > 0 else { return 0 }
    let currentOrder = self[index].order
    
    let nextIndex = self.index(after: index)
    let nextOrder = nextIndex < self.endIndex ? self[nextIndex].order : currentOrder + 1_000
    
    return (currentOrder + nextOrder) / 2
  }
}

class RemindersListViewModel: ObservableObject {
  @Published var remindersRepository: RemindersRepository
  
  @Published var sortingMode: SortingMode = .manual
  
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
      .combineLatest($sortingMode)
      .map { reminders, sortingMode in
        reminders.sorted(by: sortingMode.sorted)
      }
      .assign(to: &$reminders)
    
    // This is the beginning of some magic Firestore sauce
    //    $reminders.sink { newValue in
    //      self.dump(newValue)
    //      self.performUpdates(newValue)
    //    }
    //    .store(in: &cancellables)
    
    // the following pipeline removes empty reminder when the respective row in the list view loses focus
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
        self.remindersRepository.removeReminder(self.reminders[index])
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
    var newReminder = Reminder(title: "")

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
        
        // compute median of the elements before and after the new one
        newReminder.order = reminders.computeOrder(for: newReminder, after: index)
        
        reminders.insert(newReminder, at: index + 1)
      }
    }
    // no row focused: append at the end of the list
    else {
      newReminder.order = reminders.computeOrder(for: newReminder)
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
  
  func unfocus() {
    self.focusedReminder = nil
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
