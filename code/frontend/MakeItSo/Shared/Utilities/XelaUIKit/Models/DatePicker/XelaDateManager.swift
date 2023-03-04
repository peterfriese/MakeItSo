//
//  XelaDateManager.swift
//  XelaExampleApp
//
//  Created by Sherhan on 06.08.2021.
//

import SwiftUI

class XelaDateManager: ObservableObject {
    @Published var calendar = Calendar.current
    @Published var minimumDate: Date = Date()
    @Published var maximumDate: Date = Date()
    @Published var disabledDates: [Date] = [Date]()
    @Published var selectedDates: [Date] = [Date]()
    @Published var selectedDate: Date! = nil
    @Published var startDate: Date! = nil
    @Published var endDate: Date! = nil
    
    @Published var mode: Int = 0
    
    
    @Published var colors = XelaColorSettings()
    var cellWidth:CGFloat = 40
    
    init(calendar: Calendar, minimumDate: Date, maximumDate: Date, disabledDates:[Date] = [Date](), selectedDate:Date? = nil, selectedDates: [Date] = [Date](), mode: Int, colors:XelaColorSettings = XelaColorSettings(), cellWidth:CGFloat = 40) {
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.disabledDates = disabledDates
        self.selectedDate = selectedDate
        self.selectedDates = selectedDates
        self.mode = mode
        self.colors = colors
        self.cellWidth = cellWidth
    }
    
    
    
    func selectedDatesContains(date: Date) -> Bool {
        if let _ = self.selectedDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    func selectedDatesFindIndex(date: Date) -> Int? {
        return self.selectedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
    
    func disabledDatesContains(date: Date) -> Bool {
        if let _ = self.disabledDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    func disabledDatesFindIndex(date: Date) -> Int? {
        return self.disabledDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
}
