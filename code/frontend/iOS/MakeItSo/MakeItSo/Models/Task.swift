//
//  Task.swift
//  MakeItSo
//
//  Created by Peter Friese on 10/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum TaskPriority: Int, Codable {
  case high
  case medium
  case low
}

struct Task: Codable, Identifiable {
  @DocumentID var id: String?
  var title: String
  var priority: TaskPriority
  var completed: Bool
  @ServerTimestamp var createdTime: Timestamp?
  var userId: String?
  
  enum CodingKeys: String, CodingKey {
        case id
        case title
        case priority
        case completed
        case createdTime
        case userId
    }
  
      public init(id: String? = nil, createdTime: Timestamp? = nil, title: String, priority: TaskPriority, completed: Bool, userId: String? = nil) {
        self.id = id
        self.createdTime = createdTime
        self.title = title
        self.priority = priority
        self.completed = completed
        self.userId = userId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(DocumentID<DocumentReference>.self, forKey: .id).wrappedValue?.documentID
        createdTime = try container.decode(Timestamp.self, forKey: .createdTime)
        title = try container.decode(String.self, forKey: .title)
        priority = try container.decode(TaskPriority.self, forKey: .priority)
        completed = try container.decode(Bool.self, forKey: .completed)
        userId = try container.decode(String.self, forKey: .userId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(createdTime, forKey: .createdTime)
        try container.encode(title, forKey: .title)
        try container.encode(priority, forKey: .priority)
        try container.encode(completed, forKey: .completed)
        try container.encode(userId, forKey: .userId)
    }

}

#if DEBUG
let testDataTasks = [
  Task(title: "Implement UI", priority: .medium, completed: true),
  Task(title: "Connect to Firebase", priority: .medium, completed: false),
  Task(title: "????", priority: .high, completed: false),
  Task(title: "PROFIT!!!", priority: .high, completed: false)
]
#endif
