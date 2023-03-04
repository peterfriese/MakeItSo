//
//  XelaPieChartBody.swift
//  XelaExampleApp
//
//  Created by Sherhan on 09.08.2021.
//

import SwiftUI

struct XelaPieChartBody: View {
    
    var dataset:XelaPieDatasets
    var background:Color = Color(xelaColor: .Gray11)
    
    var endDegrees:Double = 0
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                Circle()
                    .fill(background)
                
                ForEach(0..<dataset.dataset.data.count) { i in
                    XelaChartPieItemShape(startAngle: .init(degrees: dataset.startDegrees[i]), endAngle: .init(degrees: dataset.endDegrees[i]))
                        .fill(dataset.dataset.fillColors[i])
                }
            }
        }
        
    }
}
