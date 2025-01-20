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
    guard self.count > 0 else { return 0 }
    let currentOrder = self[index].order

    let nextIndex = self.index(after: index)
    let nextOrder = nextIndex < self.endIndex ? self[nextIndex].order : currentOrder + 1_000

    return (currentOrder + nextOrder) / 2
  }
}

public enum Priority: Int, Codable, Sendable {
  case none = 0
  case low
  case medium
  case high
}

public struct TodoItem: Identifiable, Equatable, Sendable {
  /// We need the Firestore document ID so we can update / delete the document
  @DocumentID var documentId: String?

  /// The `id` is required to make the `Reminder` identifiable. We also need to persist this, otherwise
  /// it would get lost when round-tripping to Firestore, which would result in the item losing focus.
  public var id: String? = UUID().uuidString
  public var title: String
  public var priority: Priority
  public var isCompleted: Bool
  public var isFlagged: Bool
  public var order: Int = 0

  public init(
    id: String? = UUID().uuidString,
    title: String,
    priority: Priority = .none,
    isCompleted: Bool = false,
    isFlagged: Bool = false
  ) {
    if let id {
      self.id = id
    }
    else {
      self.id = UUID().uuidString
    }
    self.title = title
    self.priority = priority
    self.isCompleted = isCompleted
    self.isFlagged = isFlagged
  }
}

extension TodoItem: Codable {
  enum CodingKeys: String, CodingKey {
    case documentId = "documentId"
    case id
    case title
    case priority
    case isCompleted = "completed"
    case isFlagged = "flagged"
    case order
  }
}
