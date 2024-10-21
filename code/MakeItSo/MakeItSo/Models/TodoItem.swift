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

public enum Priority: Int, Codable, Sendable {
  case none = 0
  case low
  case medium
  case high
}

public struct TodoItem: Identifiable, Equatable, Sendable {
  public var id: String?
  public var title: String
  public var priority: Priority
  public var isCompleted: Bool
  public var isFlagged: Bool

  public init(
    id: String? = nil,
    title: String,
    priority: Priority = .none,
    isCompleted: Bool = false,
    isFlagged: Bool = false
  ) {
    if let id {
      self.id = id
    }
    self.title = title
    self.priority = priority
    self.isCompleted = isCompleted
    self.isFlagged = isFlagged
  }
}

extension TodoItem: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case priority
    case isCompleted = "completed"
    case isFlagged = "flagged"
  }
}
