//
//  XelaTooltip.swift
//  XelaExampleApp
//
//  Created by Sherhan on 03.08.2021.
//

import SwiftUI

struct XelaTooltip: View {
    @State var text:String
    
    var tooltipAlign:XelaTooltipAlign = .Top
    var arrowAlign:XelaTooltipArrowAlign = .Leading
    var textColor = Color(.white)
    var backgroundColor = Color(xelaColor: .Gray3)
    
    var body: some View {
        if tooltipAlign == .Right {
            HStack(alignment: arrowAlign == .Leading ? .top : arrowAlign == .Center ? .center : .bottom ,spacing: 0) {
                
                XelaTooltipTriangle()
                    .frame(width:14 , height: 8)
                    .foregroundColor(backgroundColor)
                    .rotationEffect(Angle(degrees: -90))
                    .offset(x:4, y: arrowAlign == .Leading ? 12 : arrowAlign == .Center ? 0 : -12)
                
                VStack {
                    Text(text)
                        .xelaCaption()
                        .foregroundColor(textColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .background(backgroundColor)
                .cornerRadius(10)
            }
        }
        else if tooltipAlign == .Left {
            HStack(alignment: arrowAlign == .Leading ? .top : arrowAlign == .Center ? .center : .bottom ,spacing: 0) {
                
                
                
                VStack {
                    Text(text)
                        .xelaCaption()
                        .foregroundColor(textColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .background(backgroundColor)
                .cornerRadius(10)
                
                XelaTooltipTriangle()
                    .frame(width:14 , height: 8)
                    .foregroundColor(backgroundColor)
                    .rotationEffect(Angle(degrees: 90))
                    .offset(x:-4, y: arrowAlign == .Leading ? 12 : arrowAlign == .Center ? 0 : -12)
            }
        }
        else if tooltipAlign == .Bottom {
            VStack(alignment: arrowAlign == .Leading ? .leading : arrowAlign == .Center ? .center : .trailing ,spacing: 0) {
                XelaTooltipTriangle()
                    .frame(width:14 , height: 8)
                    .foregroundColor(backgroundColor)
                    //.rotationEffect(Angle(degrees: 90))
                    .offset(x:arrowAlign == .Leading ? 14 : arrowAlign == .Center ? 0 : -14, y: 0)
                
                VStack {
                    Text(text)
                        .xelaCaption()
                        .foregroundColor(textColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .background(backgroundColor)
                .cornerRadius(10)
                
                
            }
        }
        else if tooltipAlign == .Top {
            VStack(alignment: arrowAlign == .Leading ? .leading : arrowAlign == .Center ? .center : .trailing ,spacing: 0) {
                
                VStack {
                    Text(text)
                        .xelaCaption()
                        .foregroundColor(textColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .background(backgroundColor)
                .cornerRadius(10)
                
                XelaTooltipTriangle()
                    .frame(width:14 , height: 8)
                    .foregroundColor(backgroundColor)
                    .rotationEffect(Angle(degrees: 180))
                    .offset(x:arrowAlign == .Leading ? 14 : arrowAlign == .Center ? 0 : -14, y: 0)
                
                
            }
        }
        
    }
}

