//
//  TaskCellViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 13/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine

class TaskCellViewModel: ObservableObject, Identifiable  {
  @Published var task: Task
  
  @Published var id: String = "_new_"
  @Published var completionStateIconName = ""
  
  private var cancellables = Set<AnyCancellable>()
  
  init(task: Task) {
    self.task = task
    
    $task.map { task in
      task.completed ? "checkmark.circle.fill" : "circle"
    }
    .assign(to: \.completionStateIconName, on: self)
    .store(in: &cancellables)

    $task.map { task in
      task.id
    }
    .assign(to: \.id, on: self)
    .store(in: &cancellables)

  }
}
