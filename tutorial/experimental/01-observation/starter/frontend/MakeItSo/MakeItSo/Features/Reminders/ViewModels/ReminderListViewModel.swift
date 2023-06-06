//
// ReminderListViewModel.swift
// MakeItSo
//
// Created by Peter Friese on 15.05.23.
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
import Factory
import Combine

class RemindersListViewModel: ObservableObject {
  @Published
  var reminders = [Reminder]()

  @Published
  var errorMessage: String?

  // MARK: - Dependencies
  @Injected(\.remindersRepository)
  private var remindersRepository: RemindersRepository

  init() {
    remindersRepository
      .$reminders
      .assign(to: &$reminders)
  }

  func addReminder(_ reminder: Reminder) {
    do {
      try remindersRepository.addReminder(reminder)
      errorMessage = nil
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func updateReminder(_ reminder: Reminder) {
    do {
      try remindersRepository.updateReminder(reminder)
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func deleteReminder(_ reminder: Reminder) {
    remindersRepository.removeReminder(reminder)
  }

  func setCompleted(_ reminder: Reminder, isCompleted: Bool) {
    var editedReminder = reminder
    editedReminder.isCompleted = isCompleted
    updateReminder(editedReminder)
  }

}
