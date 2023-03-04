//
//  XelaSlider.swift
//  XelaExampleApp
//
//  Created by Sherhan on 03.08.2021.
//

import SwiftUI

struct XelaSlider: View {
    
    
    @Binding var value: CGFloat
    var range: ClosedRange<CGFloat>
    
    var step: CGFloat = 0.1
    
    var vertical: Bool = false
        
    var primaryColor:Color = Color(xelaColor: .Blue3)
    var secondaryColor:Color = Color(xelaColor: .Gray11)
    
    var disabled:Bool = false
    
    
    
    //var tooltip:Bool = false
    
    //@State var xOffset: CGFloat = 50
    @State var lastOffset: CGFloat = 0
    var knobSize: CGSize = CGSize(width: 24, height: 24)
    
    var leadingOffset: CGFloat = -12
    var trailingOffset: CGFloat = -12
   
    @State var hover:Bool = false
    
    @State var isDragging:Bool = false
   
    var body: some View {
        if vertical {
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    ZStack {
                        VStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: isDragging ? 8 : 4, height: self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.height - self.knobSize.width - self.trailingOffset), step: step)+12)
                                .foregroundColor(primaryColor)
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: 4)
                                .foregroundColor(secondaryColor)
                            
                        }
                        .opacity(disabled ? 0.48 : 1)
                        .offset(x: isDragging ? -4 : 0)
                        
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: isDragging ? 32 : 24, height: isDragging ? 32 : 24)
                                    .foregroundColor(Color(.white))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(isDragging ? primaryColor : Color(xelaColor: .Gray12), lineWidth: isDragging ? 2 : 1)
                                    )
                                    .shadow(color: Color(.black).opacity(0.08), radius: 24, x:0 , y: -4)
                                    .shadow(color: Color(.black).opacity(0.08), radius: 4, x:0 , y: -2)
                                    
                                
                                Image(systemName: "line.horizontal.3")
                                    .font(.system(size: 14))
                                    .foregroundColor(hover ? primaryColor : secondaryColor)
                                    //.rotationEffect(Angle(degrees: 90))
                            }
                            .opacity(disabled ? 0.96 : 1)
                            //.opacity(0.5)
                            .offset(x: (isDragging ? -4 : 0), y: self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.height - self.knobSize.height - self.trailingOffset)-(isDragging ? 8 : 0), step: step))
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        withAnimation {
                                            self.isDragging = true
                                        }
                                        if abs(value.translation.height) < 0.1 {
                                            self.lastOffset = self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.height - self.knobSize.height - self.trailingOffset), step: step)
                                        }
                                        
                                        let sliderPos = max(0 + self.leadingOffset, min(self.lastOffset + value.translation.height, geometry.size.height - self.knobSize.height - self.trailingOffset))
                                        let sliderVal = sliderPos.map(from: self.leadingOffset...(geometry.size.height - self.knobSize.height - self.trailingOffset), to: self.range, step: step)
                                        
                                        self.value = sliderVal
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            self.isDragging = false
                                        }
                                    }
                                
                                    
                            )
                            
                            Spacer()
                        }
                        
                    }
                    .onHover { over in
                        hover = over
                    }
                    Spacer()
                }
            }
            .frame(width: 32)
            .rotationEffect(Angle(degrees: 180))
            .padding(.vertical, 16)
            .disabled(disabled)
            .offset(x:4)
        }
        else {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    ZStack {
        //                RoundedRectangle(cornerRadius: 100)
        //                    .frame(height:4)
        //                    .foregroundColor(Color(xelaColor: .Gray11))
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), step: step)+12, height: isDragging ? 8 : 4)
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
                            .offset(x: self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset)-(isDragging ? 8 : 0), step: step))
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        withAnimation {
                                            self.isDragging = true
                                        }
                                        if abs(value.translation.width) < 0.1 {
                                            self.lastOffset = self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), step: step)
                                        }
                                        
                                        let sliderPos = max(0 + self.leadingOffset, min(self.lastOffset + value.translation.width, geometry.size.width - self.knobSize.width - self.trailingOffset))
                                        let sliderVal = sliderPos.map(from: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), to: self.range, step: step)
                                        
                                        self.value = sliderVal
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            self.isDragging = false
                                        }
                                    }
                                
                                    
                            )
                            
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
}


