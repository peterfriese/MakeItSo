//
//	DateTimeSection.swift
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

struct DateTimeSection: View {
   @EnvironmentObject var viewModel: ReminderDetailsViewModel

   var body: some View {
      //Date -----------------------
      VStack { // Stop the date picker sliding down the screen
         Toggle(isOn: $viewModel.hasDueDate) {
            dateToggleLabel
         }
         .animation(.none, value: viewModel.pickerState )

         if viewModel.pickerState == .date {
            DatePicker("Date", selection: $viewModel.dueDate, displayedComponents: .date)
               .datePickerStyle(.graphical)
         }
      }

      //Time -----------------------
      Toggle(isOn: $viewModel.hasDueTime) {
         timeToggleLabel
      }
      if viewModel.pickerState == .time {
         DatePicker("Time", selection: $viewModel.dueDate, displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel)
      }
   }

   /*==================== Toggle label subviews for body ======================*/

   var dateToggleLabel: some View {
      HStack {
         Image(systemName: "calendar")
            .frame(width: 26, height: 26)
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(4)
         VStack(alignment: .leading) {
            Text("Date")
            if let dueDate = viewModel.reminder.dueDate {
               Button( action: viewModel.datePressed) {
                  Text(dueDate.formattedRelativeToday())
                     .font(.caption2)
                     .foregroundColor(Color.accentColor) // Accent Color, which currently defaults to blue
               }
            }
         }
      }
   }

   var timeToggleLabel: some View {
      HStack {
         Image(systemName: "clock")
            .frame(width: 26, height: 26) //, alignment: .center)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(4)
         VStack(alignment: .leading) {
            Text("Time")
            if viewModel.reminder.hasDueTime {
               Button(action: viewModel.timePressed) {
                  Text(viewModel.dueDate, style: .time)
                     .font(.caption2)
                     .foregroundColor(Color.accentColor) // Accent Color, which will default to blue
               }
            }
         }
      }
   }
}

struct DateTimeSection_Previews: PreviewProvider {
   static var previews: some View {
      NavigationView {
         Form {
            Section {
               Text("Header")
            }
            Section {
               DateTimeSection()
                  .environmentObject(ReminderDetailsViewModel(reminder: Reminder.samples[0]))
            }
            Section {
               Text("Footer")
            }
         }
      }
   }
}
