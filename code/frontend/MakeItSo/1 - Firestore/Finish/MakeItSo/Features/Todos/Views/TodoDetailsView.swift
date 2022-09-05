//
//  TodoDetailsView.swift
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

import SwiftUI
import Resolver

struct TodoDetailsView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel: TodoDetailsViewModel
  
  init(todo: Todo) {
    _viewModel = StateObject(wrappedValue: TodoDetailsViewModel(todo: todo))
  }
  
  var body: some View {
    Form {
      Section {
        TextField("Title", text: $viewModel.todo.title)
        Toggle("Completed", isOn: $viewModel.todo.completed)
      }
    }
    .onChange(of: viewModel.todo) { newValue in
      print(newValue)
      viewModel.update(todo: newValue)
    }
    .navigationTitle("Details")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct TodoDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TodoDetailsView(todo: Todo.samples[0])
    }
  }
}
