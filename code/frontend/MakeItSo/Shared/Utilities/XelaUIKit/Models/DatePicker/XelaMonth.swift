//
//  XelaMonth.swift
//  XelaExampleApp
//
//  Created by Sherhan on 07.08.2021.
//

import SwiftUI

struct XelaMonth: View {
    
    //@Binding var isPresented: Bool
    
    @ObservedObject var xelaManager: XelaDateManager
    
    @State var monthOffset: Int
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
    var monthsArray: [[Date]] {
        monthArray()
    }
    //let cellWidth = CGFloat(40)
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 0){
            
            HStack {
                Text(getYearHeader())
                    .xelaHeadline()
                    .foregroundColor(self.xelaManager.colors.yearHeaderColor)
                
                Text(getMonthHeader())
                    .xelaHeadline()
                    .foregroundColor(self.xelaManager.colors.monthHeaderColor)
                
                Spacer()
                
                XelaButton(action: {withAnimation {monthOffset -= 1}},size: .Small, type: .Secondary, background: xelaManager.colors.changeMonthButtonBackground, foregroundColor: xelaManager.colors.changeMonthButtonForeground, systemIcon: "chevron.left")
                XelaButton(action: {withAnimation {monthOffset += 1}}, size: .Small, type: .Secondary, background: xelaManager.colors.changeMonthButtonBackground, foregroundColor: xelaManager.colors.changeMonthButtonForeground, systemIcon: "chevron.right")
            }
            .frame(width: xelaManager.cellWidth*CGFloat(daysPerWeek))
            
            
            XelaDivider(style:.Dotted, color: xelaManager.colors.dividerColor)
                .frame(width:xelaManager.cellWidth*CGFloat(daysPerWeek))
                .padding(.vertical, 16)
            
            
            
            
            
            
            
            
            XelaWeekdayHeader(xelaManager: xelaManager)
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(monthsArray, id:  \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(row, id:  \.self) { column in
                            HStack(spacing:0) {
                                
                                if self.isThisMonth(date: column) {
                                    XelaDatePickerCell(xelaDate: XelaDate(
                                        date: column,
                                        xelaManager: self.xelaManager,
                                        isDisabled: !self.isEnabled(date: column),
                                        isToday: self.isToday(date: column),
                                        isSelected: self.isSpecialDate(date: column),
                                        isBetweenStartAndEnd: self.isBetweenStartAndEnd(date: column)),
                                                       cellWidth: xelaManager.cellWidth)
                                        .onTapGesture { self.dateTapped(date: column) }
                                } else {
                                    //Text("").frame(width: xelaManager.cellWidth, height: xelaManager.cellWidth)
                                    XelaDatePickerCell(xelaDate: XelaDate(
                                        date: column,
                                        xelaManager: self.xelaManager,
                                        isDisabled: true,
                                        isToday: false,
                                        isSelected: false,
                                        isBetweenStartAndEnd: false)
                                    )
                                }
                                
                            }
                        }
                    }
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: xelaManager.cellWidth*7)
            
            
        }.background(xelaManager.colors.monthBackgroundColor)
    }
    
    func isThisMonth(date: Date) -> Bool {
        return self.xelaManager.calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month)
    }
   
   func dateTapped(date: Date) {
       if self.isEnabled(date: date) {
           switch self.xelaManager.mode {
           case 0:
               if self.xelaManager.selectedDate != nil &&
                   self.xelaManager.calendar.isDate(self.xelaManager.selectedDate, inSameDayAs: date) {
                   self.xelaManager.selectedDate = nil
               } else {
                   self.xelaManager.selectedDate = date
               }
               
           case 1:
               self.xelaManager.startDate = date
               self.xelaManager.endDate = nil
               self.xelaManager.mode = 2
           case 2:
               self.xelaManager.endDate = date
               if self.isStartDateAfterEndDate() {
                   self.xelaManager.endDate = nil
                   self.xelaManager.startDate = nil
               }
               self.xelaManager.mode = 1
               //self.isPresented = false
           case 3:
               if self.xelaManager.selectedDatesContains(date: date) {
                   if let ndx = self.xelaManager.selectedDatesFindIndex(date: date) {
                    xelaManager.selectedDates.remove(at: ndx)
                   }
               } else {
                   self.xelaManager.selectedDates.append(date)
               }
           default:
               self.xelaManager.selectedDate = date
               
           }
       }
   }
    
    
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            for column in 0 ... 6 {
                let abc = self.getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }
    
    func getYearHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = xelaManager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: xelaManager.calendar.locale)
        
        return headerDateFormatter.string(from: firstOfMonthForOffset())
    }
    
    func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = xelaManager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "LLLL", options: 0, locale: xelaManager.calendar.locale)
        
        return headerDateFormatter.string(from: firstOfMonthForOffset())
    }
    
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = xelaManager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - xelaManager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset
        
        return xelaManager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }
    
    func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = xelaManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        
        return (rangeOfWeeks?.count)! * daysPerWeek
    }
    
    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        
        return xelaManager.calendar.date(byAdding: offset, to: XelaFirstDateMonth())!
    }
    
    func XelaFormatDate(date: Date) -> Date {
        let components = xelaManager.calendar.dateComponents(calendarUnitYMD, from: date)
        
        return xelaManager.calendar.date(from: components)!
    }
    
    func XelaFormatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = XelaFormatDate(date: referenceDate)
        let clampedDate = XelaFormatDate(date: date)
        return refDate == clampedDate
    }
    
    func XelaFirstDateMonth() -> Date {
        var components = xelaManager.calendar.dateComponents(calendarUnitYMD, from: xelaManager.minimumDate)
        components.day = 1
        
        return xelaManager.calendar.date(from: components)!
    }
    
    // MARK: - Date Property Checkers
    
    func isToday(date: Date) -> Bool {
        return XelaFormatAndCompareDate(date: date, referenceDate: Date())
    }
     
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) ||
            isStartDate(date: date) ||
            isEndDate(date: date) ||
            isOneOfSelectedDates(date: date)
    }
    
    func isOneOfSelectedDates(date: Date) -> Bool {
        return self.xelaManager.selectedDatesContains(date: date)
    }

    func isSelectedDate(date: Date) -> Bool {
        if xelaManager.selectedDate == nil {
            return false
        }
        return XelaFormatAndCompareDate(date: date, referenceDate: xelaManager.selectedDate)
    }
    
    func isStartDate(date: Date) -> Bool {
        if xelaManager.startDate == nil {
            return false
        }
        return XelaFormatAndCompareDate(date: date, referenceDate: xelaManager.startDate)
    }
    
    func isEndDate(date: Date) -> Bool {
        if xelaManager.endDate == nil {
            return false
        }
        return XelaFormatAndCompareDate(date: date, referenceDate: xelaManager.endDate)
    }
    
    func isBetweenStartAndEnd(date: Date) -> Bool {
        if xelaManager.startDate == nil {
            return false
        } else if xelaManager.endDate == nil {
            return false
        } else if xelaManager.calendar.compare(date, to: xelaManager.startDate, toGranularity: .day) == .orderedAscending {
            return false
        } else if xelaManager.calendar.compare(date, to: xelaManager.endDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isOneOfDisabledDates(date: Date) -> Bool {
        return self.xelaManager.disabledDatesContains(date: date)
    }
    
    func isEnabled(date: Date) -> Bool {
        let clampedDate = XelaFormatDate(date: date)
        if xelaManager.calendar.compare(clampedDate, to: xelaManager.minimumDate, toGranularity: .day) == .orderedAscending || xelaManager.calendar.compare(clampedDate, to: xelaManager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)
    }
    
    func isStartDateAfterEndDate() -> Bool {
        if xelaManager.startDate == nil {
            return false
        } else if xelaManager.endDate == nil {
            return false
        } else if xelaManager.calendar.compare(xelaManager.endDate, to: xelaManager.startDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
}

struct XelaLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

