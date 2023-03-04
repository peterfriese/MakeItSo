//
//  XelaDialog.swift
//  XelaExampleApp
//
//  Created by Sherhan on 06.08.2021.
//

import SwiftUI

struct XelaDialog: View {
    
    var icon:String = ""
    var title:String = ""
    var description:String = ""
    var primaryButton:XelaButton? = nil
    var secondaryButton:XelaButton? = nil
    var closeButton:XelaButton? = nil
    var buttonsHorizontal:Bool = true
    
    
    var background:Color = Color(.white)
    var titleColor:Color = Color(xelaColor: .Gray3)
    var descriptionColor:Color = Color(xelaColor: .Gray3)
    var iconColor:Color = Color(xelaColor: .Gray3)
    
    
    var body: some View {
        VStack {
            
            if closeButton != nil {
                HStack {
                    Spacer()
                    closeButton
                        
                }
            }
            
            if !icon.isEmpty {
                HStack {
                    Spacer()
                    Image(icon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width:40, height: 40)
                        .foregroundColor(iconColor)
                    Spacer()
                }
                .padding(.bottom, title.isEmpty && description.isEmpty ? 0 : 24)
            }
            if !title.isEmpty {
                Text(title)
                    .xelaHeadline()
                    .foregroundColor(titleColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, description.isEmpty ? 0 : 8)
            }
            if !description.isEmpty {
                Text(description)
                    .xelaBody()
                    .foregroundColor(descriptionColor)
                    .multilineTextAlignment(.center)
            }
            
            if buttonsHorizontal {
                if secondaryButton != nil || primaryButton != nil {
                    HStack(spacing:0) {
                        if secondaryButton != nil {
                            secondaryButton
                            if primaryButton != nil {
                                Spacer()
                            }
                        }
                        
                        if primaryButton != nil {
                            primaryButton
                        }
                    }
                    .padding(.top, 24)
                }
            }
            else {
                if secondaryButton != nil || primaryButton != nil {
                    VStack(spacing:8) {
                        if primaryButton != nil {
                            primaryButton
                        }
                        
                        if secondaryButton != nil {
                            secondaryButton
                        }
                    }
                    .padding(.top, 24)
                }
            }
        }
        .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
        .background(background)
        .cornerRadius(24)
        
    }
}
