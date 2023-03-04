//
//  XelaToast.swift
//  XelaExampleApp
//
//  Created by Sherhan on 07.08.2021.
//

import SwiftUI

struct XelaToast: View {
    
    var title:String
    var description:String = ""
    var icon:String? = nil
    var avatar:XelaUserAvatar? = nil
    var rightButton:XelaButton? = nil
    var firstActionText:String = ""
    var firstAction:(()->Void)? = nil
    var secondActionText:String = ""
    var secondAction:(()->Void)? = nil
    
    var autoresize:Bool = false
    
    var background:Color = Color(.white)
    var firstActionColor:Color = Color(xelaColor: .Blue3)
    var secondActionColor:Color = Color(xelaColor: .Blue3)
    var titleColor:Color = Color(xelaColor: .Gray2)
    var descriptionColor:Color = Color(xelaColor: .Gray6)
    var iconColor:Color = Color(xelaColor: .Blue3)
    
    var body: some View {
        HStack(spacing:16) {
            if avatar != nil {
                VStack {
                    if avatar != nil {
                        avatar!
                    }
                }
            }
            HStack(alignment: description.isEmpty ? .center : .top, spacing: 16) {
                if icon != nil {
                    Image(icon!)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(iconColor)
                        .frame(width:24, height:24)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .xelaBodyBold()
                        .foregroundColor(titleColor)
                    if !description.isEmpty {
                        Text(description)
                            .xelaCaption()
                            .foregroundColor(descriptionColor)
                    }
                    
                    if !firstActionText.isEmpty && !secondActionText.isEmpty {
                        HStack(spacing:18) {
                            Button(action:{
                                if firstAction != nil {
                                    firstAction!()
                                }
                            }) {
                                
                                Text(firstActionText)
                                    .xelaButtonMedium()
                            }
                            .foregroundColor(firstActionColor)
                            
                            Button(action:{
                                if secondAction != nil {
                                    secondAction!()
                                }
                            }) {
                                
                                Text(secondActionText)
                                    .xelaButtonMedium()
                            }
                            .foregroundColor(secondActionColor)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            
            if !autoresize {
                Spacer()
            }
            
            if (!secondActionText.isEmpty && firstActionText.isEmpty) || (!firstActionText.isEmpty && secondActionText.isEmpty) {
                if firstActionText.isEmpty {
                    Button(action:{
                        if secondAction != nil {
                            secondAction!()
                        }
                    }) {
                        
                        Text(secondActionText)
                            .xelaButtonMedium()
                    }
                    .foregroundColor(secondActionColor)
                }
                else {
                    Button(action:{
                        if firstAction != nil {
                            firstAction!()
                        }
                    }) {
                        
                        Text(firstActionText)
                            .xelaButtonMedium()
                    }
                    .foregroundColor(firstActionColor)
                }
            }
            
            if rightButton != nil {
                rightButton!
                    
            }
            
            
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .background(background)
        .cornerRadius(18)
        
    }
}

