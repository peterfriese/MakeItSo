//
//	View+Focus.swift
//  MakeItSo (iOS)
//
//  Created by Peter Friese on 30.10.21.
//  Copyright © 2021 Google LLC. All rights reserved.
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

import SwiftUI

/// Used to manage focus in a `List` view
enum Focusable: Hashable {
  case none
  case row(id: String?)
}

extension View {
  /// Mirror changes between an @Published variable (typically in your View Model) and
  /// an @FocusedState variable in a view
  func sync<T: Equatable>(_ field1: Binding<T>, _ field2: FocusState<T>.Binding ) -> some View {
    self
      .onChange(of: field1.wrappedValue) { field2.wrappedValue = $0 }
      .onChange(of: field2.wrappedValue) { field1.wrappedValue = $0 }
  }
}
