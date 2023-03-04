//
//  XelaChartPieItemShape.swift
//  XelaExampleApp
//
//  Created by Sherhan on 09.08.2021.
//

import SwiftUI
struct XelaChartPieItemShape:Shape {
    var startAngle:Angle
    var endAngle:Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let point = CGPoint(x: rect.width/2, y: rect.height/2)
        path.move(to: point)
            path.addArc(center: point, radius: rect.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            path.closeSubpath()
        return path
    }
}
