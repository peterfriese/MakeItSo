//
//	Dates.swift
//  MakeItSo
//
//  Created by Peter Friese, edited by Andrew Cowley  on 07/12/2021.
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
import Foundation

extension Date {
   func isTodayOrYesterdayOrTomorrow() -> Bool {
      !(   !Calendar.current.isDateInToday(self) &&
           !Calendar.current.isDateInYesterday(self) &&
           !Calendar.current.isDateInTomorrow(self)
      )
   }
   func formattedRelativeToday() -> String {
      if isTodayOrYesterdayOrTomorrow() {
         let formatStyle = Date.RelativeFormatStyle(
            presentation: .named,
            unitsStyle: .wide,
            capitalizationContext: .beginningOfSentence)

         return self.formatted(formatStyle)
      } else {
         return self.formatted(date: .complete, time: .omitted)
      }
   }

   func nearestHour() -> Date? {
      var components = Calendar.current.dateComponents([.minute], from: self)
      let minute = components.minute ?? 0
      components.minute = minute >= 30 ? 60 - minute : -minute
      return Calendar.current.date(byAdding: components, to: self)
   }

   func nextHour(basedOn date: Date? = nil) -> Date? {
      let other = date ?? self
      var timeComponents = Calendar.current.dateComponents([.hour, .minute], from: other)
      let minute = timeComponents.minute ?? 0
      timeComponents.minute = 60-minute
      return Calendar.current.date(byAdding: timeComponents, to: other)
   }

   func startOfDay() -> Date {
      Calendar.current.startOfDay(for: self)
   }
}
