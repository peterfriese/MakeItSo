//
//	TaskDetailsViewModelswift.swift
//  MakeItSo
//
//  Created by Peter Friese on 29.10.21.
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

class TaskDetailsViewModel: ObservableObject {
  @Published var task: Task
  
  init(task: Task) {
    self.task = task
  }
  
  var dueDate: Date {
    get {
      return task.dueDate ?? Date()
    }
    set {
      task.dueDate = newValue
    }
  }
  
  var dueTime: Date {
    get {
      return task.dueTime ?? Date()
    }
    set {
      task.dueTime = newValue
    }
  }

  
}
