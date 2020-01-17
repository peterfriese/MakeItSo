//
//  Task.swift
//  MakeItSo
//
//  Created by Peter Friese on 10/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation

enum TaskPriority {
  case high
  case medium
  case low
}

struct Task: Identifiable {
  var id: String = UUID().uuidString
  var title: String
  var priority: TaskPriority
  var completed: Bool
}

#if DEBUG
let testDataTasks = [
  Task(title: "Implement UI", priority: .medium, completed: false),
  Task(title: "Connect to Firebase", priority: .medium, completed: false),
  Task(title: "????", priority: .high, completed: false),
  Task(title: "PROFIT!!!", priority: .high, completed: false)
]
#endif
