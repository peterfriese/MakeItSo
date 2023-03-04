//
//  XelaColorSettings.swift
//  XelaExampleApp
//
//  Created by Sherhan on 06.08.2021.
//

import SwiftUI
struct XelaColorSettings {

    // foreground colors
    @State var textColor: Color = Color(xelaColor: .Gray3)
    var todayColor: Color = Color(xelaColor: .Blue3)
    var selectedColor: Color = Color(.white)
    var disabledColor: Color = Color(xelaColor: .Gray9)
    var betweenStartAndEndColor: Color = Color(xelaColor: .Gray3)
    // background colors
    var textBackgroundColor: Color = Color.clear
    var todayBackgroundColor: Color = Color(.white)
    var selectedBackgroundColor: Color = Color(xelaColor: .Blue3)
    var disabledBackgroundColor: Color = Color.clear
    var betweenStartAndEndBackgroundColor: Color = Color(xelaColor: .Blue8)
    // headers foreground colors
    var weekdayHeaderColor: Color = Color(xelaColor: .Gray7)
    var monthHeaderColor: Color = Color(xelaColor: .Gray2)
    var yearHeaderColor: Color = Color(xelaColor: .Gray9)
    // headers background colors
    var weekdayHeaderBackgroundColor: Color = Color.clear
    var monthBackgroundColor: Color = Color.clear
    //next & prev button colors
    var changeMonthButtonBackground: Color = Color(.white)
    var changeMonthButtonForeground: Color = Color(xelaColor: .Gray3)
    
    var dividerColor:Color = Color(xelaColor: .Gray9)

}
