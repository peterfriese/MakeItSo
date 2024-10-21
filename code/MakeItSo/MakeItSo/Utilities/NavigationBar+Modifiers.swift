//
// NavigationBar+Modifiers.swift
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

struct NavigationBarTitleFontDesign: ViewModifier {
  init(design: Font.Design, color: Color) {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.largeTitleTextAttributes[.foregroundColor] = UIColor(color)
    if design == .rounded {
      navBarAppearance.largeTitleTextAttributes[.font] = UIFont.roundedLargeTitle()
      navBarAppearance.titleTextAttributes[.font] = UIFont.roundedHeadline()
    }
    UINavigationBar.appearance().standardAppearance = navBarAppearance
  }

  func body(content: Content) -> some View {
    content
  }
}

extension View {
  func navigationBarTitleFontDesign(_ design: Font.Design, color: Color) -> some View {
    modifier(NavigationBarTitleFontDesign(design: design, color: color))
  }
}

#Preview {
  NavigationStack {
    Text("Demo")
      .navigationTitle("Title")
      .navigationBarTitleFontDesign(.rounded, color: .red)
  }
}
