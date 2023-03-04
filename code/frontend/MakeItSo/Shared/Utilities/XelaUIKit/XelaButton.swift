//
//  XelaButton.swift
//  XelaExampleApp
//
//  Created by Sherhan on 31.07.2021.
//

import SwiftUI

struct XelaButton: View {
    
    //Button text String
    @State var text:String?
    
    var action:(() -> Void)? = nil
    
    @State var leftIcon:String? = nil
    @State var rightIcon:String? = nil
    
    @State var size:XelaButtonSize = .Medium
    @State var state:XelaButtonState = .Default
    @State var type:XelaButtonType = .Primary
    @State var background:Color = Color(xelaColor: .Blue)
    @State var foregroundColor:Color = Color(.white)
    @State var defaultBorderColor:Color = Color(xelaColor: .Gray11)
    
    @State var width:CGFloat? = nil
    @State var height:CGFloat? = nil
    
    @State var autoResize = true
    
    var borderLineWidth : CGFloat = 1
    var removePaddings: Bool = false
    
    var systemIcon:String? = nil
    
    var iconsRenderingMode:Image.TemplateRenderingMode = .template
    
    @State var alignment:Alignment = .center
    
    var body: some View {
        if type == .Primary {
            Button(action: {
                if action != nil {
                    action!()
                }
            }) {
                
                
                HStack(spacing:8) {
                    if !autoResize && (alignment == .trailing || alignment == .center) {
                        Spacer()
                    }
                    
                    if systemIcon != nil {
                        Image(systemName: systemIcon!)
                            .resizable()
                            .font(.system(size: getIconSize()))
                            
//                            .renderingMode(.template)
                           .frame(width:getIconSize() , height: getIconSize())
                           .contentShape(Rectangle())
                    }
                    
                    if leftIcon != nil {
                        Image(leftIcon!)
                            .resizable()
                            .renderingMode(iconsRenderingMode)
                            .frame(width:getIconSize() , height: getIconSize())
                    }
                    
                    if text != nil {
                        if size == .Large {
                            Text(text!)
                                .xelaButtonLarge()
                        }
                        else if size == .Medium {
                            Text(text!)
                                .xelaButtonMedium()
                        }
                        else {
                            Text(text!)
                                .xelaButtonSmall()
                        }
                        
                    }
                    
                    if rightIcon != nil {
                        Image(rightIcon!)
                            .resizable()
                            .renderingMode(iconsRenderingMode)
                            .frame(width:getIconSize() , height: getIconSize())
                    }
                    
                    if !autoResize && (alignment == .leading || alignment == .center) {
                        Spacer()
                    }
                }
                //.padding(EdgeInsets(top: size == .Large ? 16 : size == .Medium ? 16 : 8, leading: size == .Large ? 24 : size == .Medium ? 16 : 16, bottom: size == .Large ? 16 : size == .Medium ? 16 : 8, trailing: size == .Large ? 24 : size == .Medium ? 16 : 16))
                .padding(.trailing, removePaddings ? 0 : rightIcon != nil && text != nil ? (size == .Large ? 23 : size == .Medium ? 15 : 7) : (size == .Large ? 23 : size == .Medium ? 15 : text != nil ? 15 : 7))
                .padding(.leading, removePaddings ? 0 : leftIcon != nil && text != nil ? (size == .Large ? 23 : size == .Medium ? 15 : 7) : (size == .Large ? 23 : size == .Medium ? 15 : text != nil ? 15 : 7))
                .padding(.vertical, removePaddings ? 0 : size == .Large ? 15 : size == .Medium ? 15 : 7)
                
            }
            .foregroundColor(foregroundColor)
            .background(background)
            .cornerRadius(size == .Small ? 12 : 16)
            //.border(background.opacity(0.8), width: 4)
            .overlay(
                RoundedRectangle(cornerRadius: size == .Small ? 12 : 16)
                    .stroke(background, lineWidth: borderLineWidth)
            )
            .opacity(state == .Disabled ? 0.4 : state == .Hover ? 0.8 : 1)
            .disabled(state == .Disabled ? true : false)
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
            .contentShape(Rectangle())
        }
        else {
            Button(action: {
                if action != nil {
                    action!()
                }
            }) {
                
                HStack(spacing:8) {
                    if !autoResize {
                        Spacer()
                    }
                    
                    if systemIcon != nil {
                        Image(systemName: systemIcon!)
                            .font(.system(size: getIconSize()))
//                            .resizable()
//                            .renderingMode(.template)
                            .frame(width:getIconSize() , height: getIconSize())
                        
                        
                    }
                    
                    if leftIcon != nil {
                        Image(leftIcon!)
                            .resizable()
                            .renderingMode(iconsRenderingMode)
                            .frame(width:getIconSize() , height: getIconSize())
                    }
                    
                    if text != nil {
                        if size == .Large {
                            Text(text!)
                                .xelaButtonLarge()
                        }
                        else if size == .Medium {
                            Text(text!)
                                .xelaButtonMedium()
                        }
                        else {
                            Text(text!)
                                .xelaButtonSmall()
                        }
                        
                    }
                    
                    if rightIcon != nil {
                        Image(rightIcon!)
                            .resizable()
                            .renderingMode(iconsRenderingMode)
                            .frame(width:getIconSize() , height: getIconSize())
                    }
                    if !autoResize {
                        Spacer()
                    }
                }
                //.padding(EdgeInsets(top: size == .Large ? 16 : size == .Medium ? 16 : 8, leading: size == .Large ? 24 : size == .Medium ? 16 : 16, bottom: size == .Large ? 16 : size == .Medium ? 16 : 8, trailing: size == .Large ? 24 : size == .Medium ? 16 : 16))
                .padding(.trailing, removePaddings ? 0 : rightIcon != nil && text != nil ? (size == .Large ? 23 : size == .Medium ? 15 : 7) : (size == .Large ? 23 : size == .Medium ? 15 : text != nil ? 15 : 7))
                .padding(.leading, removePaddings ? 0 : leftIcon != nil && text != nil ? (size == .Large ? 23 : size == .Medium ? 15 : 7) : (size == .Large ? 23 : size == .Medium ? 15 : text != nil ? 15 : 7))
                .padding(.vertical, removePaddings ? 0 : size == .Large ? 15 : size == .Medium ? 15 : 7)
                
            }
            .foregroundColor(foregroundColor)
            //.background(background)
            .cornerRadius(size == .Small ? 12 : 16)
            //.border(background.opacity(0.8), width: 4)
            .overlay(
                RoundedRectangle(cornerRadius: size == .Small ? 12 : 16)
                    .stroke(state == .Default ? defaultBorderColor : foregroundColor, lineWidth: state == .Focus ? 2 : borderLineWidth)
            )
            .opacity(state == .Disabled ? 0.4 : state == .Hover ? 0.8 : 1)
            .disabled(state == .Disabled ? true : false)
            .onHover{ over in
                if over {
                    state = .Hover
                }
                else {
                    state = .Default
                }
                
            }
            .contentShape(Rectangle())
        }
    }
    
    func getIconSize() -> CGFloat {
        if size == .Large || size == .Medium {
            return 20
        }
        
        return 15
    }
}
