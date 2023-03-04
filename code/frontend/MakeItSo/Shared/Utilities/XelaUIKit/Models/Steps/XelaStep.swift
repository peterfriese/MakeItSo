//
//  XelaStep.swift
//  XelaExampleApp
//
//  Created by Sherhan on 04.08.2021.
//

import SwiftUI

struct XelaStep: View {
    var item:XelaStepItem
    var orientation: XelaStepsOrientation
    var items:[XelaStepItem]
    
    var primaryTextColor:Color = Color(xelaColor: .Gray3)
    var secondaryTextColor:Color = Color(xelaColor: .Gray7)
    var primaryAccentColor:Color = Color(xelaColor: .Blue3)
    var secondaryAccentColor:Color = Color(xelaColor: .Blue11)
    var secondaryColor:Color = Color(xelaColor: .Gray11)
    var errorColor:Color = Color(xelaColor: .Red3)
    var iconColor:Color = Color(.white)
    
    var lines:Bool
    
    var body: some View {
        
        if orientation == .Vertical {
            VStack(alignment: .leading, spacing:0) {
                
                if items.first?.id != item.id && lines {
                    HStack {
                        if item.state == .Active || item.state == .Completed {
                            primaryAccentColor
                                .frame(width:2, height:8)
                                //.padding(.bottom, 4)
                                //.padding(.leading, 16)
                        }
                        else if item.state == .Error {
                            errorColor
                                .frame(width:2, height:8)
                                //.padding(.bottom, 4)
                                //.padding(.leading, 16)
                        }
                        else {
                            secondaryColor
                                .frame(width:2, height:8)
                                
                                //.padding(.leading, 16)
                        }
                    }
                    .frame(width:32)
                    .padding(.bottom, 4)
                }
                
                HStack(spacing:12) {
                    ZStack {
                        if item.state == .Completed {
                            Image(systemName: "checkmark")
    //                            .resizable()
    //                            .frame(width:16, height: 16)
                                .font(.system(size: 16))
                                .foregroundColor(iconColor)
                                .padding(8)
                        }
                        else if item.state == .Error {
                            Image(systemName: "xmark")
    //                            .resizable()
    //                            .frame(width:16, height: 16)
                                .font(.system(size: 16))
                                .foregroundColor(iconColor)
                                .padding(8)
                        }
                        else {
                            Text("\(item.id)")
                                .xelaButtonMedium()
                                
                                .foregroundColor(item.state == .Active ? primaryAccentColor : primaryTextColor)
                                .padding(8)
                        }
                        
                    }
                    .frame(width:32, height:32)
                    .background(item.state == .Default ? secondaryColor : item.state == .Active ? secondaryAccentColor : item.state == .Completed ? primaryAccentColor : errorColor)
                    .cornerRadius(12)
                    
                    if !item.title.isEmpty || !item.caption.isEmpty {
                        VStack(alignment:.leading, spacing:0) {
                            Text(item.title)
                                .xelaButtonMedium()
                                .foregroundColor(item.state == .Active ? primaryAccentColor : primaryTextColor)
                            Text(item.caption)
                                .xelaCaption()
                                .foregroundColor(secondaryTextColor)
                        }
                    
                    }
                }
                
                if items.last?.id != item.id && lines {
                    HStack {
                        if item.state == .Active || item.state == .Completed {
                            primaryAccentColor
                                .frame(width:2, height:8)
                               
                        }
                        else if item.state == .Error {
                            errorColor
                                .frame(width:2, height:8)
                                
                        }
                        else {
                            secondaryColor
                                .frame(width:2, height:8)
                                
                        }
                    }
                    .frame(width:32)
                    .padding(.top, 4)
                }
                
            }
        }
        else {
            HStack(spacing:0) {
                //Spacer()
                HStack(spacing:0) {
                    
                    
                    VStack(spacing:12) {
                        HStack(spacing:0) {
                            
                            
                            
                            HStack {
                                if item.state == .Active || item.state == .Completed {
                                    primaryAccentColor
                                        .frame(height:2)
                                        //.padding(.bottom, 4)
                                        //.padding(.leading, 16)
                                }
                                else if item.state == .Error {
                                    errorColor
                                        .frame(height:2)
                                        //.padding(.bottom, 4)
                                        //.padding(.leading, 16)
                                }
                                else {
                                    secondaryColor
                                        .frame(height:2)
                                        
                                        //.padding(.leading, 16)
                                }
                            }
                            .frame(height:32)
                            .padding(.trailing, 4)
                            .opacity(items.first?.id != item.id && lines ? 1 : 0)
                            
                        ZStack {
                            if item.state == .Completed {
                                Image(systemName: "checkmark")
        //                            .resizable()
        //                            .frame(width:16, height: 16)
                                    .font(.system(size: 16))
                                    .foregroundColor(iconColor)
                                    .padding(8)
                            }
                            else if item.state == .Error {
                                Image(systemName: "xmark")
        //                            .resizable()
        //                            .frame(width:16, height: 16)
                                    .font(.system(size: 16))
                                    .foregroundColor(iconColor)
                                    .padding(8)
                            }
                            else {
                                Text("\(item.id)")
                                    .xelaButtonMedium()
                                    
                                    .foregroundColor(item.state == .Active ? primaryAccentColor : primaryTextColor)
                                    .padding(8)
                            }
                            
                        }
                        .frame(width:32, height:32)
                        .background(item.state == .Default ? secondaryColor : item.state == .Active ? secondaryAccentColor : item.state == .Completed ? primaryAccentColor : errorColor)
                        .cornerRadius(12)
                            
                            
                            
                            HStack {
                                if item.state == .Active || item.state == .Completed {
                                    primaryAccentColor
                                        .frame(height:2)
                                       
                                }
                                else if item.state == .Error {
                                    errorColor
                                        .frame(height:2)
                                        
                                }
                                else {
                                    secondaryColor
                                        .frame(height:2)
                                        
                                }
                            }
                            .frame(height:32)
                            .padding(.leading, 4)
                            .opacity(items.last?.id != item.id && lines ? 1 : 0)
                            
                            
                        }
                        
                        if !item.title.isEmpty || !item.caption.isEmpty {
                            VStack(alignment:.leading, spacing:0) {
                                HStack(spacing:0) {
                                    Spacer()
                                    Text(item.title)
                                        .xelaButtonMedium()
                                        .foregroundColor(item.state == .Active ? primaryAccentColor : primaryTextColor)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }
                                HStack(spacing:0) {
                                    Spacer()
                                    Text(item.caption)
                                        .xelaCaption()
                                        .foregroundColor(secondaryTextColor)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }
                                
                            }
                        
                        }
                    }
                    
                    
                    
                    
                }
                //Spacer()
            }
            
            
        }
        
        
    }
}


