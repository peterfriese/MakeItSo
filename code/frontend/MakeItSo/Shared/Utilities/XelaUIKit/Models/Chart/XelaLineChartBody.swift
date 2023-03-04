//
//  XelaChartBody.swift
//  XelaExampleApp
//
//  Created by Sherhan on 08.08.2021.
//

import SwiftUI

struct XelaLineChartBody: View {
    var type:XelaChartType
    var labels:[String]
    @ObservedObject var datasets:XelaLineDatasets
    
    var labelsColor:Color = Color(xelaColor: .Gray6)
    var chartBorderColor:Color = Color(xelaColor: .Gray8)
    
    var labelsFormat:String = "%.0f"
    var beforeLabel:String = ""
    var afterLabel:String = ""
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                VStack(spacing:0) {
                    ForEach(datasets.steps, id: \.self) { step in
                        HStack {
                            HStack {
                                Text(beforeLabel+String(format: labelsFormat, step)+afterLabel)
                                //Text(String("\(Int(step))")+"$")
                                    .xelaCaption()
                                    .foregroundColor(labelsColor)
                            }
                            //.frame(width:30, alignment:.leading)
                            XelaDivider(orientation:.Horizontal, color:chartBorderColor)
                        }
                        .frame(height:getCellHeight(height: geometryReader.size.height))
                    }
                }

                HStack(spacing:0) {
                    ForEach(labels, id:\.self) { label in
                        VStack {
                            XelaDivider(orientation:.Vertical, color:chartBorderColor)
                                //.frame(height: getCellHeight(height: geometryReader.size.height) * CGFloat(datasets.steps.count) - 20)
                                //.offset(y:-20)
                            Text(label)
                                .xelaCaption()
                                .foregroundColor(labelsColor)
                                //.frame(height:56, alignment:.bottom)
                        }
                        .frame(width:getCellWidth(width: geometryReader.size.width), height: getCellHeight(height: geometryReader.size.height) * CGFloat(datasets.steps.count))
                    }
                }

                
                LineChartBodyView(geometryReader: geometryReader, datasets: datasets, labelsCount: labels.count, stepsCount: datasets.steps.count)
                
                
            }
            
        }
    }
    
    func getCellWidth(width:CGFloat) -> CGFloat {
        return width/CGFloat(labels.count)
    }
    
    func getCellHeight(height:CGFloat) -> CGFloat {
        return height/CGFloat(datasets.steps.count)
    }
}

@ViewBuilder
func LineChartBodyView(geometryReader:GeometryProxy, datasets:XelaLineDatasets, labelsCount:Int, stepsCount:Int) -> some View {
    ZStack {
        ForEach(datasets.datasets, id:\.self) { dataset in
            ZStack {
                LineChartFill(dataset: dataset, geometryReader: geometryReader, datasets: datasets, labelsCount: labelsCount, stepsCount: stepsCount)

                if dataset.borderColor != Color.clear {
                    XelaChartLineShape(data:dataset.data, cellWidth: (geometryReader.size.width/CGFloat(labelsCount)), cellHeight: (geometryReader.size.height/CGFloat(stepsCount)), dataStep: datasets.dataStep, firstStep: datasets.steps.last!, tension: dataset.tension)
                        .stroke(dataset.borderColor, lineWidth: 2)
                }

                if dataset.pointColor != Color.clear {
                    ForEach(0..<dataset.data.count) { i in
                        LineChartPoint(i: i, geometryReader: geometryReader, dataset: dataset, datasets: datasets, labelsCount: labelsCount, stepsCount: stepsCount)
                    }

                }
            }
        }
    }
}

@ViewBuilder
func LineChartFill(dataset:XelaLineChartDataset, geometryReader:GeometryProxy, datasets:XelaLineDatasets, labelsCount:Int, stepsCount:Int) -> some View {
    if dataset.fillColor != Color.clear {
        XelaChartLineShape(data:dataset.data, cellWidth: (geometryReader.size.width / CGFloat(labelsCount)), cellHeight: (geometryReader.size.height/CGFloat(stepsCount)), dataStep: datasets.dataStep, firstStep: datasets.steps.last!, tension: dataset.tension, filled: true)
            .fill(dataset.fillColor.opacity(0.24))
    }
}

@ViewBuilder
func LineChartPoint(i:Int, geometryReader:GeometryProxy, dataset:XelaLineChartDataset, datasets:XelaLineDatasets, labelsCount:Int, stepsCount:Int) -> some View {
    Circle()
        .fill(Color(.white))
        .frame(width:6, height:6)
        .overlay(
            Circle()
                .stroke(dataset.pointColor, lineWidth:2)

        )
        .offset(x: CGFloat(i)*(geometryReader.size.width/CGFloat(labelsCount)) - geometryReader.size.width/2 + (geometryReader.size.width/CGFloat(labelsCount))/2, y: geometryReader.size.height - (dataset.data[i]*(( geometryReader.size.height/CGFloat(stepsCount))/datasets.dataStep)) + datasets.steps.last!*(( geometryReader.size.height/CGFloat(stepsCount))/datasets.dataStep) - (geometryReader.size.height/CGFloat(stepsCount))/2 - 1 - geometryReader.size.height/2)
}
