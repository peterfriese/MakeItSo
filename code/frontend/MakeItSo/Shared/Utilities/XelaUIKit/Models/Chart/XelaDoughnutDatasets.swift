//
//  XelaDoughnutDatasets.swift
//  XelaExampleApp
//
//  Created by Sherhan on 10.08.2021.
//

import SwiftUI
class XelaDoughnutDatasets: ObservableObject {
    @Published var datasets:[XelaDoughnutChartDataset]
    @Published var sum:CGFloat
    @Published var startDegreeses:[[Double]] = [[Double]]()
    @Published var endDegreeses:[[Double]] = [[Double]]()
    
    init(datasets:[XelaDoughnutChartDataset], total:CGFloat) {
        self.datasets = datasets
        
        sum = total
        for i in 0..<datasets.count {
            let dataset = datasets[i]
            var startDegrees:[Double] = [Double]()
            var endDegrees:[Double] = [Double]()
            var tempEndDegrees:Double = -90
            for data in dataset.data {
                let temp = Double((data * 360 / self.sum))
                startDegrees.append(tempEndDegrees)
                endDegrees.append(tempEndDegrees + temp)
                
                tempEndDegrees += temp
                
            }
            
            //print(tempEndDegrees)
            
            startDegrees.append(tempEndDegrees)
            endDegrees.append(tempEndDegrees + 360 - tempEndDegrees)
            
            self.datasets[i].fillColors.append(Color(xelaColor: .Gray11))
            
            
            startDegreeses.append(startDegrees)
            endDegreeses.append(endDegrees)
        }
    }
}
