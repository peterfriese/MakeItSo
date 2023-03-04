//
//  XelaToggleStyle.swift
//  XelaExampleApp
//
//  Created by Sherhan on 02.08.2021.
//

import SwiftUI
struct XelaToggleStyle:ToggleStyle {
    var icon:String = ""
    var size:XelaToggleSize = .Large
    var onBackgound:Color = Color(xelaColor: .Blue3)
    var offBackground:Color = Color(xelaColor: .Gray11)
    var iconOnColor:Color = Color(xelaColor: .Blue3)
    var iconOffColor:Color = Color(xelaColor: .Gray8)
    var circleOnColor:Color = Color(.white)
    var circleOffColor:Color = Color(.white)
    var isEmptyLabel = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
     
        HStack {

            if !isEmptyLabel {
                configuration.label
                Spacer()
            }
            
            HStack {
                if configuration.isOn {
                    Spacer()
                }
                ZStack {
                    Circle()
                        .fill(configuration.isOn ? circleOnColor : circleOffColor)
                        .frame(width: getCircleSize(), height: getCircleSize())
                        .shadow(color: Color(.black).opacity(0.08), radius: 24, x:0 , y: 4)
                        .shadow(color: Color(.black).opacity(0.08),radius: 4, x:0 , y: 2)
                    
                    if !icon.isEmpty {
                        Image(icon)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: getIconSize(), height: getIconSize())
                            .foregroundColor(configuration.isOn ? iconOnColor : iconOffColor)
                    }
                    
                }
                .padding(.horizontal, size == .Large ? 4 : size == .Medium ? 2 : 1)
                if !configuration.isOn {
                    Spacer()
                }
            }
            .frame(width:getWidth(), height: getHeight())
            .background(configuration.isOn ? onBackgound : offBackground)
            .clipShape(RoundedRectangle(cornerRadius: 100))
            

        }
        .onTapGesture {
            withAnimation {
                configuration.isOn.toggle()
            }
        }
     
    }
    
    func getIconSize() -> CGFloat {
        if size == .Small {
            return 14
        }
        
        return 16
    }
    
    func getCircleSize() -> CGFloat {
        if size == .Large {
            return 24
        }
        else if size == .Medium {
            return 20
        }
        
        return 14
    }
    
    func getHeight() -> CGFloat {
        if size == .Large {
            return 32
        }
        else if size == .Medium {
            return 24
        }
        
        return 16
    }
    
    func getWidth() -> CGFloat {
        if size == .Large {
            return 56
        }
        else if size == .Medium {
            return 48
        }
        
        return 32
    }
}
