//
//  XelaTabs.swift
//  XelaExampleApp
//
//  Created by Sherhan on 05.08.2021.
//

import SwiftUI

struct XelaTabs: View {
    var items:[XelaTabsItem]
    @Binding var selectedId:Int
    var primaryColor:Color = Color(xelaColor: .Blue6)
    var secondaryColor:Color = Color(xelaColor: .Gray6)
    var badgeBackground:Color = Color(xelaColor: .Orange3)
    var badgeTextColor:Color = Color(.white)
    
    var badgeBackgroundSelected:Color = Color(xelaColor: .Orange3)
    var badgeTextColorSelected:Color = Color(.white)
    
    var bottomLineColor:Color = Color(xelaColor: .Gray10)
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment:.leading, spacing:0) {
                
                HStack(spacing:8) {
                   
                    ForEach(items) { item in
                        XelaTab(item: item, selectedId: $selectedId, primaryColor: primaryColor, secondaryColor: secondaryColor, badgeBackground: badgeBackground, badgeTextColor: badgeTextColor, badgeBackgroundSelected: badgeBackgroundSelected, badgeTextColorSelected: badgeTextColorSelected)
                    }
                    
                }
                
                Rectangle()
                    .foregroundColor(bottomLineColor)
                    .frame(height:1)
                
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(primaryColor)
                    .frame(width: geometry.size.width/CGFloat(items.count), height: 3)
                    .offset(x: (geometry.size.width/CGFloat(items.count))*CGFloat(selectedId - items.first!.id), y:-3)
                    
                
                
                    
                
            }
        }
        .frame(height:46)
        
        
    }
}

