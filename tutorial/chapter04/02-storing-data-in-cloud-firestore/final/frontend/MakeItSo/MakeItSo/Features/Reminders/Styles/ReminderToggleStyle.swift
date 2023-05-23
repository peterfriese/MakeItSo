//
// ReminderToggleStyle.swift
// MakeItSo
//
// Created by Peter Friese on 16.05.23.
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

struct ReminderToggleStyle: ToggleStyle {
  private let onStyle: AnyShapeStyle = AnyShapeStyle(.tint)
  private let offStyle: AnyShapeStyle = AnyShapeStyle(.gray)

  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Image(systemName: configuration.isOn ? "largecircle.fill.circle" : "circle")
        .resizable()
        .frame(width: 24, height: 24)
        .foregroundStyle(configuration.isOn ? onStyle : offStyle)
        .onTapGesture {
          configuration.isOn.toggle()
        }
      configuration.label
    }
  }
}

extension ToggleStyle where Self == ReminderToggleStyle {
  static var reminder: ReminderToggleStyle {
    ReminderToggleStyle()
  }
}


struct ReminderToggleStyle_Previews: PreviewProvider {
  struct Container: View {
    @State var isOn = false
    var body: some View {
      Toggle(isOn: $isOn) { Text("Hello") }
        .toggleStyle(.reminder)

    }
  }

  static var previews: some View {
    Container()
  }
}
