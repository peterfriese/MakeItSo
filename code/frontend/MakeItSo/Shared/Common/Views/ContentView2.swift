//
//	ContentView2.swift
//  MakeItSo (iOS)
//
//  Created by Peter Friese on 12.11.21.
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

struct ContentView2: View {
  @State var isEmpty = true
  var body: some View {
    Text("Hello, World!")
      .emptyState($isEmpty) {
        Text("Sorry - no content available")
      }
  }
}

struct ContentView2_Previews: PreviewProvider {
  static var previews: some View {
    ContentView2()
  }
}
