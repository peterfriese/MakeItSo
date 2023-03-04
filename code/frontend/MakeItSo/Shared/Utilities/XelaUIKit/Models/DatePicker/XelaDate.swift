//
//  XelaDate.swift
//  XelaExampleApp
//
//  Created by Sherhan on 06.08.2021.
//

import SwiftUI

struct XelaDate {
    var date:Date
    
    var xelaManager:XelaDateManager
    
    var isDisabled:Bool = false
    var isToday:Bool = false
    var isSelected:Bool = false
    var isBetweenStartAndEnd:Bool = false
    
    func getText() -> String {
        let day = formatDate(date: date, calendar: self.xelaManager.calendar)
        return day
    }
    
    func getTextColor() -> Color {
        var textColor = xelaManager.colors.textColor
        if isDisabled {
            textColor = xelaManager.colors.disabledColor
        } else if isSelected {
            textColor = xelaManager.colors.selectedColor
        } else if isToday {
            textColor = xelaManager.colors.todayColor
        } else if isBetweenStartAndEnd {
            textColor = xelaManager.colors.betweenStartAndEndColor
        }
        return textColor
    }
    
    func getBackgroundColor() -> Color {
        var backgroundColor = xelaManager.colors.textBackgroundColor
        if isBetweenStartAndEnd {
            backgroundColor = xelaManager.colors.betweenStartAndEndBackgroundColor
        }
        if isToday {
            backgroundColor = xelaManager.colors.todayBackgroundColor
        }
        if isDisabled {
            backgroundColor = xelaManager.colors.disabledBackgroundColor
        }
        if isSelected {
            backgroundColor = xelaManager.colors.selectedBackgroundColor
        }
        return backgroundColor
    }
    
    func getChangeMonthBackgroundColor() -> Color {
        return xelaManager.colors.changeMonthButtonBackground
    }
    
    func getChangeMonthForegroundColor() -> Color {
        return xelaManager.colors.changeMonthButtonForeground
    }
    
    func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = dateFormatter()
        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter
    }
    
    func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
    
}
