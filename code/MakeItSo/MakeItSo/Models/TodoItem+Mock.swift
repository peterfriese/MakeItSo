//
// TodoItem+Mock.swift
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

extension TodoItem: Mockable {
  public static var mockList: [TodoItem] = [
    .init(id: UUID().uuidString, title: "Build a to-do list app", priority: .low, isCompleted: true),
    .init(id: UUID().uuidString, title: "Write a blog post", priority: .high, isCompleted: false),
    .init(id: UUID().uuidString, title: "???", priority: .none, isCompleted: false),
    .init(
      id: UUID().uuidString,
      title: "PROFIT!!!",
      priority: .medium,
      isCompleted: false,
      isFlagged: true
    ),
  ]
}
