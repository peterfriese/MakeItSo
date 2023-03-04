//
//  XelaChartLineShape.swift
//  XelaExampleApp
//
//  Created by Sherhan on 08.08.2021.
//

import SwiftUI

struct XelaChartLineShape: Shape {
    var data:[CGFloat]
    var cellWidth:CGFloat
    var cellHeight:CGFloat
    var dataStep:CGFloat
    var firstStep:CGFloat
    var tension:CGFloat
    var filled:Bool = false
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let offsetY:CGFloat = cellHeight/dataStep
        
        var prevPoint:CGPoint = CGPoint(x: 0, y: 0)
        
        for i in 0..<data.count {
            let dataValue = data[i]
            let point:CGPoint = CGPoint(x: CGFloat(i) * cellWidth + cellWidth / 2, y: rect.height - (dataValue * offsetY) + firstStep * offsetY - cellHeight / 2)
            
            
            
            
            if i == 0 {
                if filled {
                    path.move(to: CGPoint(x: CGFloat(i) * cellWidth + cellWidth / 2, y: rect.height - cellHeight / 2))
                    path.addLine(to: CGPoint(x: CGFloat(i) * cellWidth + cellWidth / 2, y: rect.height - cellHeight / 2))
                }
                
                //path.move(to: point)
                path.move(to: point)
                prevPoint = point
                continue
            }
            
            let deltaX = point.x - prevPoint.x
            let curveXOffset = deltaX * tension
            
            path.addCurve(to: point, control1: .init(x: prevPoint.x + curveXOffset, y: prevPoint.y), control2: .init(x: point.x - curveXOffset, y: point.y))
            

            
            
            if filled && i == data.count-1 {
                //path.move(to: CGPoint(x: CGFloat(i)*cellWidth + cellWidth/2, y: rect.height))
                
                path.addLine(to: CGPoint(x: CGFloat(i) * cellWidth + cellWidth / 2, y: rect.height - cellHeight / 2))
                
                path.addLine(to: CGPoint(x:cellWidth / 2, y:rect.height - cellHeight / 2))
            }
            
            
            prevPoint = point

        }
        
        return path
    }
}

