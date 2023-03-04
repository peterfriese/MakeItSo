//
//  XelaDoughnutChartBody.swift
//  XelaExampleApp
//
//  Created by Sherhan on 09.08.2021.
//

import SwiftUI

struct XelaDoughnutChartBody: View {
    var datasets:XelaDoughnutDatasets
    var background:Color = Color.white
    var emptyColor:Color = Color(xelaColor: .Gray11)
    
    var endDegrees:Double = 0
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
            ForEach(0..<datasets.datasets.count) { j in
                ZStack {
                    Circle()
                        .fill(emptyColor)
                    
                    ForEach(0..<datasets.datasets[j].data.count) { i in
                        XelaChartPieItemShape(startAngle: .init(degrees: datasets.startDegreeses[j][i]), endAngle: .init(degrees: datasets.endDegreeses[j][i]))
                            .fill(datasets.datasets[j].fillColors[i])
                        
                    }
                    
                    Circle()
                        .fill(background)
                        .frame(width: getWidth(width: geometryReader.size.width, index: j) - geometryReader.size.width * 0.075)
                }
                .frame(width: getWidth(width: geometryReader.size.width, index: j))
            }
            }
        }
        
    }
    
    func getBgWidth(width:CGFloat, index:Int) -> CGFloat {
        let value = width - (width * 0.075) * CGFloat(index)
        return value
    }
    
    func getWidth(width:CGFloat, index:Int) -> CGFloat {
        let value = width - (width * 0.15) * CGFloat(index)
        return value
    }
}
