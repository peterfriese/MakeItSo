//
//  TaskRepository.swift
//  MakeItSo
//
//  Created by Peter Friese on 14/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Disk

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions

import Combine
import Resolver

class BaseTaskRepository {
  @Published var tasks = [Task]()
}

protocol TaskRepository: BaseTaskRepository {
  func addTask(_ task: Task)
  func removeTask(_ task: Task)
  func updateTask(_ task: Task)
}

class TestDataTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
  override init() {
    super.init()
    self.tasks = testDataTasks
  }
  
  func addTask(_ task: Task) {
    tasks.append(task)
  }
  
  func removeTask(_ task: Task) {
    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
      tasks.remove(at: index)
    }
  }
  
  func updateTask(_ task: Task) {
    if let index = self.tasks.firstIndex(where: { $0.id == task.id } ) {
      self.tasks[index] = task
    }
  }
}

class LocalTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
  override init() {
    super.init()
    loadData()
  }
  
  func addTask(_ task: Task) {
    self.tasks.append(task)
    saveData()
  }
  
  func removeTask(_ task: Task) {
    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
      tasks.remove(at: index)
      saveData()
    }
  }
  
  func updateTask(_ task: Task) {
    if let index = self.tasks.firstIndex(where: { $0.id == task.id } ) {
      self.tasks[index] = task
      saveData()
    }
  }
  
  private func loadData() {
    if let retrievedTasks = try? Disk.retrieve("tasks.json", from: .documents, as: [Task].self) {
      self.tasks = retrievedTasks
    }
  }
  
  private func saveData() {
    do {
      try Disk.save(self.tasks, to: .documents, as: "tasks.json")
    }
    catch let error as NSError {
      fatalError("""
        Domain: \(error.domain)
        Code: \(error.code)
        Description: \(error.localizedDescription)
        Failure Reason: \(error.localizedFailureReason ?? "")
        Suggestions: \(error.localizedRecoverySuggestion ?? "")
        """)
    }
  }
}

class FirestoreTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
  @Injected var db: Firestore
  @Injected var authenticationService: AuthenticationService
  @LazyInjected var functions: Functions

  var tasksPath: String = "tasks"
  var userId: String = "unknown"
  
  private var listenerRegistration: ListenerRegistration?
  private var cancellables = Set<AnyCancellable>()
  
  override init() {
    super.init()
    
    authenticationService.$user
      .compactMap { user in
        user?.uid
      }
      .assign(to: \.userId, on: self)
      .store(in: &cancellables)
    
    // (re)load data if user changes
    authenticationService.$user
      .receive(on: DispatchQueue.main)
      .sink { user in
        self.loadData()
      }
      .store(in: &cancellables)
  }
  
  private func loadData() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
    }
    listenerRegistration = db.collection(tasksPath)
      .whereField("userId", isEqualTo: self.userId)
      .order(by: "createdTime")
      .addSnapshotListener { (querySnapshot, error) in
        if let querySnapshot = querySnapshot {
          self.tasks = querySnapshot.documents.compactMap { document -> Task? in
            try? document.data(as: Task.self)
          }
        }
      }
  }
  
  func addTask(_ task: Task) {
    do {
      var userTask = task
      userTask.userId = self.userId
      let _ = try db.collection(tasksPath).addDocument(from: userTask)
    }
    catch {
      fatalError("Unable to encode task: \(error.localizedDescription).")
    }
  }
  
  func removeTask(_ task: Task) {
    if let taskID = task.id {
      db.collection(tasksPath).document(taskID).delete { (error) in
        if let error = error {
          print("Unable to remove document: \(error.localizedDescription)")
        }
      }
    }
  }
  
  func updateTask(_ task: Task) {
    if let taskID = task.id {
      do {
        try db.collection(tasksPath).document(taskID).setData(from: task)
      }
      catch {
        fatalError("Unable to encode task: \(error.localizedDescription).")
      }
    }
  }
  
  func migrateTasks(fromUserId: String) {
    let data = ["previousUserId": fromUserId]
    functions.httpsCallable("migrateTasks").call(data) { (result, error) in
      if let error = error as NSError? {
        print("Error: \(error.localizedDescription)")
      }
      print("Function result: \(result?.data ?? "(empty)")")
    }
  }
}
