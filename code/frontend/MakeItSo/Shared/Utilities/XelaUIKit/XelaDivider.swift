//
//  XelaDivider.swift
//  XelaExampleApp
//
//  Created by Sherhan on 07.08.2021.
//

import SwiftUI

struct XelaDivider: View {
    
    var style:XelaDividerStyle = .Solid
    var orientation:XelaDividerOrientation = .Horizontal
    var color:Color = Color(xelaColor: .Gray11)
    
    var body: some View {
        if orientation == .Horizontal {
            if style == .Dotted {
                XelaHorizontalLine()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [2, 6]))
                    .frame(height: 2)
                    .foregroundColor(color)
            }
            else if style == .Dashed {
                XelaHorizontalLine()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [8, 4]))
                    .frame(height: 1)
                    .foregroundColor(color)
            }
            else {
                XelaHorizontalLine()
                    .stroke(lineWidth: 1)
                    .frame(height: 1)
                    .foregroundColor(color)
            }
            
        }
        else {
            if style == .Dotted {
                XelaVerticalLine()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [2, 6]))
                    .frame(width: 2)
                    .foregroundColor(color)
            }
            else if style == .Dashed {
                XelaVerticalLine()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [8, 4]))
                    .frame(width: 1)
                    .foregroundColor(color)
            }
            else {
                XelaVerticalLine()
                    .stroke(lineWidth: 1)
                    .frame(width: 1)
                    .foregroundColor(color)
            }
        }
        
    }
}

struct XelaHorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct XelaVerticalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}
