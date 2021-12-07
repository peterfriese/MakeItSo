//
//	InsetPicker.swift
//  MakeItSo
//
//  Created by Andrew Cowley on 07/12/2021.
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

/// Drill down picker with a grouped list style
struct InsetPicker<T: Pickable>: View where T.AllCases: RandomAccessCollection {
   /* Argument */
   @Binding var selectedValue: T
   let title: String
   /* Configuration */
   @State private var showPicker = false

   var body: some View {
      formText
      // Add .padding to create space for the chevron overlayed by navlink
         .padding(.trailing, 20)
         .overlay {
            NavigationLink(" ", isActive: $showPicker ) {
               listPicker
            }
         }
   }

   /// The row on the calling view that will be clicked to trigger the picker
   var formText: some View {
      HStack {
         Text("\(title)")
         Spacer()
         Text("\(selectedValue.description)")
            .foregroundColor(Color.secondary)
      }
   }

   /// Picker styled on an insetGrouped List
   var listPicker: some View {
      List {
         ForEach(T.allCases) { t in
            HStack {
               Text(t.description)
               Spacer()
               checkmark(for: t)
            }
            // Overlay an invisible button across each row
            .overlay(selectionButton(t: t))
         }
      }
      .listStyle(.insetGrouped)
      .toolbar {
         ToolbarItem(placement: .principal) {
            Text(title)
         }
      }
   }

   func selectionButton(t: T) -> some View {
      Button(" ") {
         // Replicate slightly annoying feature where the current row cannot
         // be selected to dismiss the picker
         guard selectedValue != t else { return }
         selectedValue = t
         // Uncomment line below to enable auto return after selecting a value
         //         showPicker = false
      }
   }
   /// Return a checkmark if the supplied value matches the selectedValue
   func checkmark(for t: T) -> some View {
      Group {
         if t == selectedValue {
            Text(Image(systemName: "checkmark"))
               .foregroundColor(Color.accentColor)
               .bold()
         } else {
            EmptyView()
         }
      }
   }

   init(_ title: String, selection v: Binding<T>) {
      self.title = title
      self._selectedValue = v
      self.showPicker = true
   }
}

protocol Pickable: Identifiable, Equatable, CaseIterable, RawRepresentable {
   var description: String {get}
}

extension Pickable {
   var id: String { "\(self.rawValue)" }
   var description: String { "\(self.rawValue)".capitalized }
}
