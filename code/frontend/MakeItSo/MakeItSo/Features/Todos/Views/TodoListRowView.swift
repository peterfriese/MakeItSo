//
//  TodoListRowView.swift
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

struct TodoListRowView: View {
  @ObservedObject var viewModel: TodoListRowViewModel
  
  init(todo: Binding<Todo>) {
    viewModel = TodoListRowViewModel(todo: todo)
  }

  var body: some View {
    HStack(alignment: .top) {
      Image(systemName: viewModel.todo.completed ? "checkmark.circle.fill" : "circle")
        .foregroundColor(viewModel.todo.completed ? Color(UIColor.systemRed) : .gray)
        .font(.title3)
        .onTapGesture {
          viewModel.toggleCompletion()
//          todo.completed.toggle()
        }
      VStack(alignment: .leading) {
        HStack {
          Text(viewModel.todo.title)
        }
      }
      Spacer()
    }
  }
}

struct TodoListRowView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListRowView(todo: .constant(Todo.samples[0]))
      .previewLayout(.sizeThatFits)
  }
}
