//
//  XelaRangeSlider.swift
//  XelaExampleApp
//
//  Created by Sherhan on 03.08.2021.
//

import SwiftUI

struct XelaRangeSlider: View {
    @Binding var valueLeft: CGFloat
    @Binding var valueRight: CGFloat
    var range: ClosedRange<CGFloat>
    
    var step: CGFloat = 0.1
        
    var primaryColor:Color = Color(xelaColor: .Blue3)
    var secondaryColor:Color = Color(xelaColor: .Gray11)
    
    var disabled:Bool = false
    
    
    @State var lastOffsetLeft: CGFloat = 0
    @State var lastOffsetRight: CGFloat = 0
    var knobSize: CGSize = CGSize(width: 24, height: 24)
    
    var leadingOffset: CGFloat = -12
    var trailingOffset: CGFloat = -12
   
    @State var hover:Bool = false
    
    @State var isDragging:Bool = false
    
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    
                    HStack(spacing: 0) {
                        
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: self.$valueLeft.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), step: step)+12, height: 4)
                            .foregroundColor(secondaryColor)
                        
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: self.$valueRight.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), step: step) - self.$valueLeft.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), step: step), height: isDragging ? 8 : 4)
                            .foregroundColor(primaryColor)
                        
                        
                        RoundedRectangle(cornerRadius: 100)
                            .frame(height: 4)
                            .foregroundColor(secondaryColor)
                        
                       
                    }
                    .opacity(disabled ? 0.48 : 1)
                    
                    
                    
                    HStack {
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: isDragging ? 32 : 24, height: isDragging ? 32 : 24)
                                .foregroundColor(Color(.white))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(isDragging ? primaryColor : Color(xelaColor: .Gray12), lineWidth: isDragging ? 2 : 1)
                                )
                                .shadow(color: Color(.black).opacity(0.08), radius: 24, x:0 , y: 4)
                                .shadow(color: Color(.black).opacity(0.08), radius: 4, x:0 , y: 2)
                                
                            
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 14))
                                .foregroundColor(hover ? primaryColor : secondaryColor)
                                .rotationEffect(Angle(degrees: 90))
                        }
                        .opacity(disabled ? 0.96 : 1)
                        //.opacity(0.5)
                        .offset(x: self.$valueLeft.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset)-(isDragging ? 8 : 0), step: step))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    withAnimation {
                                        self.isDragging = true
                                    }
                                    if abs(value.translation.width) < 0.1 {
                                        self.lastOffsetLeft = self.$valueLeft.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), step: step)
                                    }
                                    
                                    let sliderPos = max(0 + self.leadingOffset, min(self.lastOffsetLeft + value.translation.width, geometry.size.width - self.knobSize.width - self.trailingOffset))
                                    let sliderVal = sliderPos.map(from: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), to: self.range, step: step)
                                    
                                    if self.valueRight > sliderVal {
                                        self.valueLeft = sliderVal
                                    }
                                   
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        self.isDragging = false
                                    }
                                }
                            
                                
                        )
                        
                        
                        Spacer()
                    }
                    
                    HStack {
                        
                        
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: isDragging ? 32 : 24, height: isDragging ? 32 : 24)
                                .foregroundColor(Color(.white))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(isDragging ? primaryColor : Color(xelaColor: .Gray12), lineWidth: isDragging ? 2 : 1)
                                )
                                .shadow(color: Color(.black).opacity(0.08), radius: 24, x:0 , y: 4)
                                .shadow(color: Color(.black).opacity(0.08), radius: 4, x:0 , y: 2)
                                
                            
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 14))
                                .foregroundColor(hover ? primaryColor : secondaryColor)
                                .rotationEffect(Angle(degrees: 90))
                        }
                        .opacity(disabled ? 0.96 : 1)
                        //.opacity(0.5)
                        .offset(x: self.$valueRight.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset)-(isDragging ? 8 : 0), step: step))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    withAnimation {
                                        self.isDragging = true
                                    }
                                    if abs(value.translation.width) < 0.1 {
                                        self.lastOffsetRight = self.$valueRight.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), step: step)
                                    }
                                    
                                    let sliderPos = max(0 + self.leadingOffset, min(self.lastOffsetRight + value.translation.width, geometry.size.width - self.knobSize.width - self.trailingOffset))
                                    let sliderVal = sliderPos.map(from: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), to: self.range, step: step)
                                    
                                    if sliderVal > self.valueLeft {
                                        self.valueRight = sliderVal
                                    }
                                    
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        self.isDragging = false
                                    }
                                }
                            
                                
                        )
                        
                        
//
                        
                        Spacer()
                    }
//                    if isDragging {
//                        GeometryReader { xelaTooltipGeometry in
//                            XelaTooltip(text: "\(value)", tooltipAlign: .Top, arrowAlign: .Center)
//                                .frame(width: 100)
//                                .offset(x: self.$value.wrappedValue.map(from: self.range, to: (-50)...(geometry.size.width - 50))+4, y: -40)
//                        }
//                    }
                }
                .onHover { over in
                    hover = over
                }
                Spacer()
            }
            .offset(y: isDragging ? -8 : -4)
            //.frame(height: isDragging ? 32 : 24)
            
        }
        .frame(height: 32)
        .padding(.horizontal, 16)
        .disabled(disabled)
        
    }
}
