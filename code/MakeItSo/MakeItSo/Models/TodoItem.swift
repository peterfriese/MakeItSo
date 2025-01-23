//
// TodoItem.swift
// MakeItSo
//
// Created by Peter Friese on 21.10.24.
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
@preconcurrency import FirebaseFirestore

extension Array where Element == TodoItem {
  func computeOrder(for item: TodoItem) -> Int {
    let index = self.endIndex == 0 ? 0 : self.endIndex - 1
    return self.computeOrder(for: item, after: index)
  }

  func computeOrder(for item: TodoItem, after index: Int) -> Int {
    guard self.count > 0 else { return 10_000 }
    let currentOrder = self[index].order

    let nextIndex = self.index(after: index)
    let nextOrder = nextIndex < self.endIndex ? self[nextIndex].order : currentOrder + 10_000

    return currentOrder + ((nextOrder - currentOrder) / 2)
  }
}

public enum Priority: Int, Codable, Sendable {
  case none = 0
  case low
  case medium
  case high
}

public struct TodoItem: Identifiable, Equatable, Sendable {
  @DocumentID public var id: String?

  public var title: String
  public var priority: Priority
  public var isCompleted: Bool
  public var isFlagged: Bool
  public var order: Int = 0

  public init(
    id: String? = nil,
    title: String,
    priority: Priority = .none,
    isCompleted: Bool = false,
    isFlagged: Bool = false
  ) {
    self.id = id
    self.title = title
    self.priority = priority
    self.isCompleted = isCompleted
    self.isFlagged = isFlagged
  }
}

extension TodoItem: Codable {
  enum CodingKeys: String, CodingKey {
    case id // even though we don't store the document ID as a field, it needs to be encoded/decoded
    case title
    case priority
    case isCompleted = "completed"
    case isFlagged = "flagged"
    case order
  }
}
