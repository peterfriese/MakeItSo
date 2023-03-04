//
//  XelaDatePickerCell.swift
//  XelaExampleApp
//
//  Created by Sherhan on 06.08.2021.
//

import SwiftUI

struct XelaDatePickerCell: View {
    var xelaDate:XelaDate
    
    var cellWidth:CGFloat = 40
    
    var borderLineWidth:CGFloat = 2
    
    var body: some View {
        if xelaDate.isDisabled {
            Text(xelaDate.getText())
                .xelaSmallBody()
                .foregroundColor(xelaDate.getTextColor())
                .frame(width: xelaDate.xelaManager.cellWidth , height: xelaDate.xelaManager.cellWidth)
                .background(xelaDate.getBackgroundColor())
                .cornerRadius(8)
        }
        else {
            ZStack {
                
                Rectangle()
                    .fill(xelaDate.getBackgroundColor())
                    .frame(width: xelaDate.xelaManager.cellWidth, height: xelaDate.xelaManager.cellWidth-10)
                    .opacity(xelaDate.isBetweenStartAndEnd && !xelaDate.isSelected ? 1 : 0)
                
                Text(xelaDate.getText())
                    .xelaButtonMedium()
                    .foregroundColor(xelaDate.getTextColor())
                    .frame(width: xelaDate.xelaManager.cellWidth, height: xelaDate.xelaManager.cellWidth)
                    .background(xelaDate.isBetweenStartAndEnd && !xelaDate.isSelected ? Color.clear : xelaDate.getBackgroundColor())
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(xelaDate.getTextColor(), lineWidth: borderLineWidth)
                            .opacity(xelaDate.isToday && !xelaDate.isSelected ? 1 : 0)
                    )
                
            }
                
        }
        
    }
}

struct XelaDatePickerCell_Previews: PreviewProvider {
    static var previews: some View {
        XelaDatePickerCell(xelaDate: XelaDate(date: Date(), xelaManager: XelaDateManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)))
    }
}
