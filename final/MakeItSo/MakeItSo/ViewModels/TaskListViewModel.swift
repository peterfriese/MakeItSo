//
//  TaskListViewModel.swift
//  MakeItSo
//
//  Created by Peter Friese on 13/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine
import Resolver

class TaskListViewModel: ObservableObject {
  @Published var taskRepository: TaskRepository = Resolver.resolve()
  @Published var taskCellViewModels = [TaskCellViewModel]()
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    taskRepository.$tasks.map { tasks in
      tasks.map { task in
        TaskCellViewModel(task: task)
      }
    }
    .assign(to: \.taskCellViewModels, on: self)
    .store(in: &cancellables)
  }
  
  func removeTasks(atOffsets indexSet: IndexSet) {
    // remove from repo
    let viewModels = indexSet.lazy.map { self.taskCellViewModels[$0] }
    viewModels.forEach { taskCellViewModel in
      taskRepository.removeTask(taskCellViewModel.task)
    }
  }
  
  func addTask(task: Task) {
    taskRepository.addTask(task)
  }
}
