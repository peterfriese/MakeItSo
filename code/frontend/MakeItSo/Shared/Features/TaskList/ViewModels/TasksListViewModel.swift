//
//	TasksListViewModel.swift
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

class TasksListViewModel: ObservableObject {
  @Published var tasks: [Task]
  @Published var focusedTask: Focusable?
  var previousFocusedTask: Focusable?
  
  private var cancellables = Set<AnyCancellable>()
  
  init(tasks: [Task]) {
    self.tasks = tasks
    
    // This is the beginning of some magic Firestore sauce
    //    $tasks.sink { newValue in
    //      self.dump(newValue)
    //      self.performUpdates(newValue)
    //    }
    //    .store(in: &cancellables)
    
    // the following pipeline removes empty tasks when the respecive row in the list view loses focus
    $focusedTask
      .removeDuplicates()
      .compactMap { focusedTask -> Int? in
        defer { self.previousFocusedTask = focusedTask }
        
        guard focusedTask != nil else { return nil }
        guard case .row(let previousId) = self.previousFocusedTask else { return nil }
        guard let previousIndex = self.tasks.firstIndex(where: { $0.id == previousId } ) else { return nil }
        guard self.tasks[previousIndex].title.isEmpty else { return nil }
        
        return previousIndex
      }
      .delay(for: 0.01, scheduler: RunLoop.main) // <-- this helps reduce the visual jank
      .sink { index in
        self.tasks.remove(at: index)
      }
      .store(in: &cancellables)

// This is the unoptimised version. It results in visual jank.
//    $focusedTask
//      .removeDuplicates()
//      .sink { focusedTask in
//        if case .row(let previousId) = self.previousFocusedTask, case .row(let currentId) = focusedTask {
//          print("Previous: \(previousId)")
//          print("Current: \(currentId)")
//          if let previousIndex = self.tasks.firstIndex(where: { $0.id == previousId } ) {
//            if self.tasks[previousIndex].title.isEmpty {
//              self.tasks.remove(at: previousIndex)
//            }
//          }
//        }
//        self.previousFocusedTask = focusedTask
//      }
//      .store(in: &cancellables)
  }
  
  func createNewTask() {
    let newTask = Task(title: "")

    // if any row is focused, insert the new task after the focused row
    if case .row(let id) = focusedTask {
      if let index = tasks.firstIndex(where: { $0.id == id } ) {
        
        // If the currently selected task is empty, unfocus it.
        // This will kick off the pipeline that removes empty tasks.
        let currentTask = tasks[index]
        guard !currentTask.title.isEmpty else {
          focusedTask = Focusable.none
          return
        }
        
        tasks.insert(newTask, at: index + 1)
      }
    }
    // no row focused: append at the end of the list
    else {
      tasks.append(newTask)
    }
    
    // focus the new task
    focusedTask = .row(id: newTask.id)
  }
  
  func deleteTask(_ task: Task) {
    Just(task)
      .delay(for: .seconds(0.25), scheduler: RunLoop.main)
      .sink { task in
        self.tasks.removeAll { $0.id == task.id }
      }
      .store(in: &cancellables)
  }
  
  func flagTask(_ task: Task) {
    if let index = tasks.firstIndex(of: task) {
      tasks[index].flagged.toggle()
    }
  }
  
}


extension TasksListViewModel {
  func dump(_ newValue: [Task]) {
    print("--->>>")
    print("Object value")
    print(self.tasks)
    print("Closure value")
    print(newValue)
    print("<<<---")
  }
  
  func performUpdates(_ newValue: [Task]) {
    let difference = newValue.difference(from: self.tasks)
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
