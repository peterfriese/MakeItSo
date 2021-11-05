//
//	TaskListRowViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 05.11.21.
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
import SwiftUI

class TaskListRowViewModel: ObservableObject {
  @Binding var task: Task
  
  init(task: Binding<Task>) {
    self._task = task
  }
  
  var priorityAdornment: String {
    String(repeating: "!", count: (task.priority.index ?? 0))
  }
}
