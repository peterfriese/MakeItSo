//
//  XelaRadioButtonGroup.swift
//  XelaExampleApp
//
//  Created by Sherhan on 02.08.2021.
//

import SwiftUI

struct XelaRadioButtonGroup: View {
    let items : [XelaRadioButtonItem]
    var itemBorder:Bool = false
    var size:XelaRadioButtonSize = .Large
    var selectedColor:Color = Color(xelaColor: .Blue3)
    var defaultColor:Color = Color(xelaColor: .Gray11)
    @State var selectedItem: XelaRadioButtonItem? = nil

    let callback: (XelaRadioButtonItem) -> ()
    

    var body: some View {
        VStack {
            ForEach(0..<items.count) { index in
                XelaRadioButton(self.items[index], callback: self.radioGroupCallback, selectedItem: self.selectedItem, selectedColor: selectedColor, defaultColor: defaultColor, size: size == .Large ? 32 : size == .Medium ? 24 : 20, itemBorder: itemBorder)
            }
        }
    }

    func radioGroupCallback(item: XelaRadioButtonItem) {
        selectedItem = item
        callback(item)
    }
}

struct XelaRadioButton: View {

    var item: XelaRadioButtonItem
    let callback: (XelaRadioButtonItem)->()
    let selectedItem : XelaRadioButtonItem?
    let selectedColor: Color
    let defaultColor: Color
    let size: CGFloat
    let itemBorder:Bool
    
    @State var hover:Bool = false
    
    init(
        _ item: XelaRadioButtonItem,
        callback: @escaping (XelaRadioButtonItem)->(),
        selectedItem: XelaRadioButtonItem?,
        selectedColor: Color,
        defaultColor: Color,
        size: CGFloat = 32,
        itemBorder:Bool = false
        ) {
        self.item = item
        self.size = size
        self.selectedColor = selectedColor
        self.selectedItem = selectedItem
        self.defaultColor = defaultColor
        self.itemBorder = itemBorder
        self.callback = callback
        
    }

    var body: some View {
        Button(action:{
            self.callback(self.item)
        }) {
            HStack(alignment: .center, spacing: 16) {
                Circle()
                    .strokeBorder(self.selectedItem?.id == self.item.id || hover ? selectedColor : defaultColor, lineWidth: self.selectedItem?.id == self.item.id ? (size == 32 ? 8 : size == 24 ? 6 : 5) : 2)
                    .frame(width: self.size, height: self.size)
                
                if !item.label.isEmpty || !item.caption.isEmpty {
                    VStack(alignment:.leading, spacing:0) {
                        
                        
                        
                        if !item.label.isEmpty {
                            Text(item.label)
                                .xelaButtonMedium()
                                .foregroundColor(Color(xelaColor: .Gray2))
                        }
                        
                        if !item.caption.isEmpty {
                            Text(item.caption)
                                .xelaCaption()
                                .foregroundColor(Color(xelaColor: .Gray8))
                        }
                    }
                }
                Spacer()
                
                if !item.value.isEmpty {
                    Text(item.value)
                        .xelaButtonLarge()
                        .foregroundColor(Color(xelaColor: .Gray2))
                }
            }
        }
        .disabled(item.state == .Disabled ? true : false)
        .opacity(item.state == .Disabled ? 0.48 : 1)
        .onHover { over in
            if item.state != .Disabled {
                hover = over
            }
        }
        .padding(EdgeInsets(top: getPadding(), leading: getPadding(), bottom: getPadding(), trailing: getPadding()))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(self.selectedItem?.id == self.item.id || hover ? selectedColor : defaultColor, lineWidth: 1).opacity(itemBorder ? 1 : 0)
        )
        
        
    }
    
    func getPadding() -> CGFloat {
        if itemBorder {
            return 16
        }
        return 0
    }
}


