//
//  XelaTooltipTriangle.swift
//  XelaExampleApp
//
//  Created by Sherhan on 03.08.2021.
//

import SwiftUI
struct XelaTooltipTriangle:Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}
