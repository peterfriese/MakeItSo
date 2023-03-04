//
//  XelaNumberInput.swift
//  XelaExampleApp
//
//  Created by Sherhan on 01.08.2021.
//

import SwiftUI

struct XelaNumberInput: View {
    @Binding var value:Int
    @Binding var helperText:String
    @State var label:String? = nil
    
    @Binding var state:XelaNumberInputState
    @State var controls:XelaNumberInputControls = .LeftRight
    
    @State var decreaseIcon:String
    @State var increaseIcon:String
    
    var labelColor: Color = Color(xelaColor: .Gray8)
    var valueColor: Color = Color(xelaColor: .Gray2)
    
    var helperTextColor: Color = Color(xelaColor: .Gray8)
    
    var controlsColor: Color = Color(xelaColor: .Gray2)
    
    var defaultBackground:Color = Color(.white)
    var disabledBackground:Color = Color(xelaColor: .Gray12)
    
    var defaultBorderColor:Color = Color(xelaColor: .Gray11)
    var focusBorderColor:Color = Color(xelaColor: .Blue5)
    var errorBorderColor: Color = Color(xelaColor: .Red3)
    var successBorderColor:Color = Color(xelaColor: .Green1)
    var hoverBorderColor:Color = Color(xelaColor: .Blue5)
    var disabledBorderColor:Color = Color(xelaColor: .Gray8)
    
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                if controls == .LeftRight || controls == .Left {
                    VStack(spacing:8) {
                        if controls == .LeftRight {
                            decreaseBtn()
                        }
                        else if controls == .Left {
                            increaseBtn()
                            decreaseBtn()
                            
                        }
                    }
                    Spacer()
                }
                
                VStack(alignment: controls == .Left ? .trailing : controls == .Right ? .leading : .center, spacing:0) {
                    if label != nil {
                        Text(label!)
                            .xelaSmallBody()
                            .lineLimit(1)
                            .foregroundColor(labelColor)
                            .padding(.bottom, 5)
                    }
                    Text("\(value)")
                        .xelaButtonMedium()
                        .lineLimit(1)
                        .foregroundColor(valueColor)
                }
                .frame(height:35)
                
                if controls == .LeftRight || controls == .Right {
                    Spacer()
                    VStack(spacing:8) {
                        if controls == .LeftRight {
                            increaseBtn()
                        }
                        else if controls == .Right {
                            increaseBtn()
                            decreaseBtn()
                        }
                    }
                }
                
            }
            .frame(width:144-32)
            .frame(height:40)
            //.font(.system(size: 14, weight: .bold))
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(state == .Disabled ? disabledBackground : defaultBackground)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(state == .Disabled ? disabledBorderColor : state == .Error ? errorBorderColor : state == .Success ? successBorderColor : state == .Hover ? hoverBorderColor : state == .Focus ? focusBorderColor : defaultBorderColor, lineWidth: state == .Focus ? 2 : 1)
            )
            .onHover{ over in
                
                if over {
                    if state == .Default {
                        state = .Hover
                    }
                }
                else {
                    state = .Default
                }
            }
            
            if !helperText.isEmpty {
                Text(helperText)
                    .xelaCaption()
                    .foregroundColor(helperTextColor)
            }
        }
    }
    
    @ViewBuilder func decreaseBtn() -> some View {
        Button(action:{
            value -= 1
        }){
            Image(decreaseIcon)
                .resizable()
                .frame(width:15 , height: 15)
                .foregroundColor(controlsColor)
        }
    }
    
    @ViewBuilder func increaseBtn() -> some View {
        Button(action:{
            value += 1
        }) {
            Image(increaseIcon)
                .resizable()
                .frame(width:15 , height: 15)
                .foregroundColor(controlsColor)
        }
    }
}
