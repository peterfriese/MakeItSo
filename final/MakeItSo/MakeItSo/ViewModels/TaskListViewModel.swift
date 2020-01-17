//
//  TaskListViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 13/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
  @Published var taskCellViewModels = [TaskCellViewModel]()
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    self.taskCellViewModels = testDataTasks.map { task in
      TaskCellViewModel(task: task)
    }
  }
}
