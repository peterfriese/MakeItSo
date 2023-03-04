//
//  XelaBarChartBody.swift
//  XelaExampleApp
//
//  Created by Sherhan on 09.08.2021.
//

import SwiftUI

struct XelaBarChartBody: View {
    var type:XelaChartType
    var labels:[String]
    @ObservedObject var datasets:XelaBarDatasets
    
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
                            .frame(width:30)
                            XelaDivider(orientation:.Horizontal, color:Color.clear)
                        }
                        .frame(height:getCellHeight(height: geometryReader.size.height))
                    }
                }

                HStack(spacing:0) {
                    //ForEach(labels, id:\.self) { label in
                    ForEach(0..<labels.count) { i in
                        VStack {
                            HStack(spacing:0) {
                                
                                ForEach(datasets.datasets, id:\.self) { dataset in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: (getCellWidth(width: geometryReader.size.width))/CGFloat(datasets.datasets.count)*0.21)
                                            .fill(chartBorderColor)
                                            .frame(width:(getCellWidth(width: geometryReader.size.width))/CGFloat(datasets.datasets.count))
                                        VStack(spacing:0) {
                                            Spacer()
                                            RoundedRectangle(cornerRadius: (getCellWidth(width: geometryReader.size.width))/CGFloat(datasets.datasets.count)*0.21)
                                                .fill(dataset.fillColor)
                                                .frame(
                                                    width:(getCellWidth(width: geometryReader.size.width))/CGFloat(datasets.datasets.count),
                                                    height: (dataset.data[i]*(getCellHeight(height: geometryReader.size.height)/datasets.dataStep))
                                                )
                                        }
                                        
                                        //geometryReader.size.height - (dataset.data[i]*(getCellHeight(height: geometryReader.size.height)/datasets.dataStep)) + datasets.steps.last!*(getCellHeight(height: geometryReader.size.height)/datasets.dataStep) - getCellHeight(height: geometryReader.size.height)/2 - 1 - geometryReader.size.height/2
                                    }
                                    .padding(.horizontal, 2)
                                }
                            }
                            
                                
                            Text(labels[i])
                                .xelaCaption()
                                .foregroundColor(labelsColor)
                                .frame(height:24)
                        }
                        .frame(width:getCellWidth(width: geometryReader.size.width), height: getCellHeight(height: geometryReader.size.height) * CGFloat(datasets.steps.count))
                        .padding(.horizontal, CGFloat((datasets.datasets.count+1)*2))
                    }
                }
                .padding(.leading, 30)
                
//                 ZStack {
//                    ForEach(datasets.datasets, id:\.self) { dataset in
//                        ForEach(0..<dataset.data.count) { i in
//
//                                RoundedRectangle(cornerRadius: CGFloat(12 - 2 * datasets.datasets.count))
//                                    .fill(dataset.fillColor)
//                                    .frame(
//                                        width:(getCellWidth(width: geometryReader.size.width)-12)/CGFloat(datasets.datasets.count),
//                                        height: getCellHeight(height: geometryReader.size.height)
//                                    )
//                                    .offset(x: CGFloat(i)*getCellWidth(width: geometryReader.size.width) - (geometryReader.size.width-30)/2 + (getCellWidth(width: geometryReader.size.width)-12)/CGFloat(datasets.datasets.count)/2+2)
//                                    .padding(.leading, 30)
//
//
//                            //Circle()
//                        //                                        .fill(Color(.white))
//                        //                                        .frame(width:6, height:6)
//                        //                                        .overlay(
//                        //                                            Circle()
//                        //                                                .stroke(dataset.pointColor, lineWidth:2)
//                        //
//                        //                                        )
//                        //                                        .offset(x: CGFloat(i)*getCellWidth(width: geometryReader.size.width) - geometryReader.size.width/2 + getCellWidth(width: geometryReader.size.width)/2, y: geometryReader.size.height - (dataset.data[i]*(getCellHeight(height: geometryReader.size.height)/datasets.dataStep)) + datasets.steps.last!*(getCellHeight(height: geometryReader.size.height)/datasets.dataStep) - getCellHeight(height: geometryReader.size.height)/2 - 1 - geometryReader.size.height/2)
//                        //                                }
//                        }
//                    }
//                }
               

//                ZStack {
//                    ForEach(datasets.datasets, id:\.self) { dataset in
//                        ZStack {
//                            if dataset.fillColor != Color.clear {
//                                XelaChartLineShape(data:dataset.data, cellWidth: getCellWidth(width: geometryReader.size.width), cellHeight: getCellHeight(height: geometryReader.size.height), dataStep: datasets.dataStep, firstStep: datasets.steps.last!, tension: dataset.tension, filled: true)
//                                    .fill(dataset.fillColor.opacity(0.24))
//                            }
//
//                            if dataset.borderColor != Color.clear {
//                                XelaChartLineShape(data:dataset.data, cellWidth: getCellWidth(width: geometryReader.size.width), cellHeight: getCellHeight(height: geometryReader.size.height), dataStep: datasets.dataStep, firstStep: datasets.steps.last!, tension: dataset.tension)
//                                    .stroke(dataset.borderColor, lineWidth: 2)
//                            }
//
//                            if dataset.pointColor != Color.clear {
//                                ForEach(0..<dataset.data.count) { i in
//                                    Circle()
//                                        .fill(Color(.white))
//                                        .frame(width:6, height:6)
//                                        .overlay(
//                                            Circle()
//                                                .stroke(dataset.pointColor, lineWidth:2)
//
//                                        )
//                                        .offset(x: CGFloat(i)*getCellWidth(width: geometryReader.size.width) - geometryReader.size.width/2 + getCellWidth(width: geometryReader.size.width)/2, y: geometryReader.size.height - (dataset.data[i]*(getCellHeight(height: geometryReader.size.height)/datasets.dataStep)) + datasets.steps.last!*(getCellHeight(height: geometryReader.size.height)/datasets.dataStep) - getCellHeight(height: geometryReader.size.height)/2 - 1 - geometryReader.size.height/2)
//                                }
//
//
//                            }
//                        }
//                    }
//                }
            }
            
        }
    }
    
    func getCellWidth(width:CGFloat) -> CGFloat {
        
        let offsetX = Int((datasets.datasets.count+1)*2)*2*labels.count
        //offsetX = 0
        
        return (width - 30 - CGFloat(offsetX))/CGFloat(labels.count)
    }
    
    func getCellHeight(height:CGFloat) -> CGFloat {
        return height/CGFloat(datasets.steps.count)
    }
}
