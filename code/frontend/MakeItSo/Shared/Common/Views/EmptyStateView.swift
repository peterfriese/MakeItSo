//
//	EmptyStateView.swift
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

struct Inner: View {
  @Binding var hasContent: Bool
  
  var body: some View {
    Label("Here is the content", systemImage: "heart")
      .frame(width: 200, height: 200, alignment: .center)
//      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .background(.green)
      .emptyState($hasContent) {
        Text("We don't have any content, sorry 😔")
          .frame(width: 300, height: 300, alignment: .center)
//          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
          .background(.blue)
      }
//      .emptyState3(hasContent) {
//        Text("We don't have any content, sorry 😔")
//          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//          .background(.blue)
//      }
//      .emptyState4($hasContent) {
//        Text("We don't have any content, sorry 😔")
//          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//          .background(.blue)
//      }
      .foregroundColor(hasContent ? .red : .blue)
      .debug()
  }
}


struct EmptyStateDemo: View {
  @State var hasContent: Bool = true
  
  var body: some View {
      VStack {
        Toggle(isOn: $hasContent) {
          Text("Has Content")
        }
        Button("Toggle") {
          withAnimation {
            self.hasContent.toggle()
          }
        }
        Inner(hasContent: $hasContent)
//          .animation(.default, value: hasContent)
      }
//      .debug()
  }
}

extension View {
  func debug() -> Self {
    print(Mirror(reflecting: self).subjectType)
    return self
  }
}

// MARK: - Approach 1

struct EmptyStateView<EmptyContent, Content>: View where EmptyContent: View, Content: View {
  @Binding var isEmpty: Bool
  private var emptyContent: () -> EmptyContent
  private var content: () -> Content
  
  init(_ isEmpty: Binding<Bool>, @ViewBuilder emptyContent: @escaping () -> EmptyContent, @ViewBuilder content: @escaping () -> Content) {
    self._isEmpty = isEmpty
    self.emptyContent = emptyContent
    self.content = content
  }
  
  var body: some View {
    if isEmpty {
      emptyContent()
    }
    else {
      content()
    }
  }
}

extension View {
  func emptyState1<EmptyContent>(_ isEmpty: Binding<Bool>, @ViewBuilder emptyContent: @escaping () -> EmptyContent) -> some View where EmptyContent: View {
    EmptyStateView(isEmpty) {
      emptyContent()
    } content: {
      self
    }
  }
}

// MARK: - Approach 2


struct EmptyStateViewModifier<EmptyContent>: ViewModifier where EmptyContent: View {
  @Binding var isEmpty: Bool
  let emptyContent: () -> EmptyContent
  
  func body(content: Content) -> some View {
    if isEmpty {
      emptyContent()
    }
    else {
      content
    }
  }
}

extension View {
  func emptyState<EmptyContent>(_ isEmpty: Binding<Bool>,
                                emptyContent: @escaping () -> EmptyContent) -> some View where EmptyContent: View {
    modifier(EmptyStateViewModifier(isEmpty: isEmpty, emptyContent: emptyContent))
  }
}

// MARK: - Approach 3

extension View {
  func emptyState3<EmptyContent>(_ isEmpty: Bool, @ViewBuilder emptyContent: @escaping () -> EmptyContent) -> some View where EmptyContent: View {
    self
      .opacity(isEmpty ? 0 : 100)
      .background {
        emptyContent()
          .opacity(isEmpty ? 100 : 0)
      }
  }
}

// MARK: - Approach 4

struct EmptyStateViewModifier4<EmptyContent>: ViewModifier where EmptyContent: View {
  @Binding var isEmpty: Bool
  var emptyContent: () -> EmptyContent
  
  func body(content: Content) -> some View {
    content
      .opacity(isEmpty ? 0 : 100)
      .background {
        emptyContent()
          .opacity(isEmpty ? 100 : 0)
      }
  }
}

extension View {
  func emptyState4<EmptyContent>(_ isEmpty: Binding<Bool>, @ViewBuilder emptyContent: @escaping () -> EmptyContent) -> some View where EmptyContent: View {
    modifier(EmptyStateViewModifier4(isEmpty: isEmpty, emptyContent: emptyContent))
  }
}




struct EmptyStateView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Label("Content", systemImage: "heart")
        .emptyState(.constant(true)) {
          Text("We don't have any content, sorry 😔")
        }

      EmptyStateView(.constant(false)) {
        Text("No content")
      } content: {
        Label("Content", systemImage: "heart")
      }
    }
  }
}
