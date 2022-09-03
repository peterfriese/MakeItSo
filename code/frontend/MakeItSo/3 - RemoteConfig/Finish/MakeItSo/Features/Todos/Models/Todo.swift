//
//  Todo.swift
//  MakeItSo
//
//  Created by Peter Friese on 26.07.22.
//  Copyright © 2022 Google LLC. All rights reserved.
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
import FirebaseFirestoreSwift

struct Todo {
  /// We need the Firestore document ID so we can update / delete the document
  @DocumentID var docId: String?
  
  /// The `id` is required to make the `Todo` identifiable. We also need to persist this, otherwise
  /// it would get lost when round-tripping to Firestore, which would result in the item losing focus.
  var id: String? = UUID().uuidString

  var title: String
  var completed: Bool = false
  var userId: String?
}

extension Todo: Codable, Identifiable, Equatable, Hashable {
}

extension Todo {
  static let samples = [
    Todo(title: "Build sample app", completed: true),
    Todo(title: "Tweet about surprising findings"),
    Todo(title: "Write newsletter"),
    Todo(title: "Run YouTube video series"),
    Todo(title: "???"),
    Todo(title: "PROFIT!!")
  ]
}

