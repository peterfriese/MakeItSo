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
  
  private var cancellables = Set<AnyCancellable>()
  
  init(tasks: [Task]) {
    self.tasks = tasks
    
    $tasks.sink { newValue in
      self.dump(newValue)
      self.performUpdates(newValue)
    }
    .store(in: &cancellables)
  }
  
  func createNewTask() {
    self.tasks.append(Task(title: ""))
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
