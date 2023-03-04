//
//  XelaBarDatasets.swift
//  XelaExampleApp
//
//  Created by Sherhan on 09.08.2021.
//

import SwiftUI
class XelaBarDatasets: ObservableObject {
    @Published var datasets:[XelaBarChartDataset]
    @Published var minValue:CGFloat = 0
    @Published var maxValue:CGFloat = 0
    @Published var dataStep:CGFloat = 10
    @Published var beginAtZero:Bool = true
    @Published var steps:[CGFloat] = [CGFloat]()
    
    init(datasets:[XelaBarChartDataset], dataStep:CGFloat) {
        self.datasets = datasets
        self.beginAtZero = beginAtZero
        self.dataStep = dataStep
        for dataset in datasets {
            for dataItem in dataset.data {
                if maxValue < dataItem {
                    maxValue = dataItem
                }
                if minValue == 0 {
                    minValue = dataItem
                }
                if minValue > dataItem {
                    minValue = dataItem
                }
            }
        }
        
        let fromStep:CGFloat = maxValue + (dataStep - maxValue.truncatingRemainder(dividingBy: dataStep))
        let toStep:CGFloat = minValue - (dataStep - minValue.truncatingRemainder(dividingBy: dataStep)) - dataStep
        
        
        
        for index in stride(from: fromStep, to: beginAtZero && minValue > 0 ? 0 - dataStep : toStep, by: -dataStep) {
            
            steps.append(index)
        }
        
    }
}
