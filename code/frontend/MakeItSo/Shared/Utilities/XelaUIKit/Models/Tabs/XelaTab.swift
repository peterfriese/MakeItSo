//
//  XelaTab.swift
//  XelaExampleApp
//
//  Created by Sherhan on 05.08.2021.
//

import SwiftUI

struct XelaTab: View {
    var item:XelaTabsItem
    @Binding var selectedId:Int
    var primaryColor:Color = Color(xelaColor: .Blue6)
    var secondaryColor:Color = Color(xelaColor: .Gray6)
    var badgeBackground:Color = Color(xelaColor: .Orange3)
    var badgeTextColor:Color = Color(.white)
    
    var badgeBackgroundSelected:Color = Color(xelaColor: .Orange3)
    var badgeTextColorSelected:Color = Color(.white)
    
    var body: some View {
        
        HStack(spacing:8) {
            Spacer()
            if !item.icon.isEmpty {
                Image(item.icon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width:15, height: 15)
                    .foregroundColor(item.id == selectedId ? primaryColor : secondaryColor)
                    //.padding(.trailing, item.label.isEmpty ? 0 : 8)
            }
            if !item.label.isEmpty {
                Text(item.label)
                    .xelaButtonMedium()
                    .foregroundColor(item.id == selectedId ? primaryColor : secondaryColor)
            }
            if !item.badgeText.isEmpty {
                HStack {
                    Text(item.badgeText)
                        .font(.system(size: 12))
                        .padding(4)
                        .foregroundColor(item.id == selectedId ? badgeTextColorSelected : badgeTextColor)
                        
                        
                }
                .frame(minWidth:16)
                .frame(height:16)
                .background(item.id == selectedId ? badgeBackgroundSelected : badgeBackground)
                .cornerRadius(6)
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: getPadding(), bottom: 16, trailing: getPadding()))
        .contentShape(Rectangle())
        //.cornerRadius(12)
        .onTapGesture {
            withAnimation {
                selectedId = item.id
            }
        }
    }
    
    func getPadding() -> CGFloat {
        return 0
    }
}

