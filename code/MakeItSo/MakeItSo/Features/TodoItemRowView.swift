//
// TodoItemRowView.swift
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

import SwiftUI

/// Use this flag to turn multi line text fields on / off. At the moment, it's not possible to
/// use multi-line text fields and the `onSubmit` event handler together. Since most tasks will
/// less than two lines, we're going to prefer supporting `onSubmit` over multi-line tasks for now.
private let MULTI_LINE_TEXT_FIELD = false

struct TodoItemRowView: View {
  @Binding var todoItem: TodoItem

  var body: some View {
    HStack(alignment: .top) {
      Image(systemName: todoItem.isCompleted ? "largecircle.fill.circle" : "circle")
        .resizable()
        .frame(width: 24, height: 24)
        .foregroundColor(todoItem.isCompleted ? .accentColor : .gray)
        .contentShape(Rectangle())
        .onTapGesture {
          todoItem.isCompleted.toggle()
        }
      Text(String(repeating: "!", count: todoItem.priority.rawValue))
        .foregroundStyle(Color.accentColor)
#if MULTI_LINE_TEXT_FIELD
      TextField("", text: $todoItem.title, axis: .vertical)
#else
      TextField("", text: $todoItem.title)
#endif
      Spacer()
      if todoItem.isFlagged {
        Image(systemName: "flag.fill")
          .foregroundStyle(Color(.systemOrange))
      }
    }
  }
}

#Preview {
  @Previewable @State var todoItem = TodoItem.mock
  NavigationStack {
    List {
      TodoItemRowView(todoItem: $todoItem)
    }
    .listStyle(.plain)
    .navigationTitle("To-dos")
  }
}

#Preview {
  @Previewable @State var todoItems = TodoItem.mockList
  NavigationStack {
    List($todoItems) { $todoItem in
      TodoItemRowView(todoItem: $todoItem)
    }
    .listStyle(.plain)
    .navigationTitle("To-dos")
  }
}

