//
//  XelaCheckbox.swift
//  XelaExampleApp
//
//  Created by Sherhan on 02.08.2021.
//

import SwiftUI

struct XelaCheckbox: View {
    var label: String = ""
    var caption: String = ""
    var value:String = ""
    var selectedColor: Color = Color(xelaColor: .Blue3)
    var defaultColor: Color = Color(xelaColor: .Gray11)
    var valueColor: Color = Color(xelaColor: .Red3)
    var size: XelaCheckboxSize = .Large
    @State var state:XelaCheckboxState = .Default
    @State var hover:Bool = false
    @State var disabled:Bool = false
    
    @State var indeterminate:Bool = false
    
    var labelColor:Color = Color(xelaColor: .Gray2)
    var captionColor:Color = Color(xelaColor: .Gray8)

    var body: some View {
        Button(action:{
            //self.callback(self.item)
            if indeterminate {
                if state == .Indeterminate {
                    state = .Default
                }
                else {
                    state = .Indeterminate
                }
            }
            else {
                if state == .Selected {
                    state = .Default
                }
                else {
                    state = .Selected
                }
            }
            
            
        }) {
            HStack(alignment: .center, spacing: 16) {
                VStack {
                    if state == .Selected {
                        Image(systemName: "checkmark")
                            .font(.system(size: size == .Small ? 12 : 15))
                            .foregroundColor(Color(.white))
                    }
                    else if state == .Indeterminate {
                        Image(systemName: "minus")
                            .font(.system(size: size == .Small ? 12 : 15))
                            .foregroundColor(Color(.white))
                    }
                    
                }
                .frame(width: getSize(), height: getSize())
                .background(state == .Selected || state == .Indeterminate || hover ? selectedColor : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: size == .Large ? 12 : size == .Medium ? 9 : 8)
                        .strokeBorder(state == .Selected || state == .Indeterminate || hover ? selectedColor : defaultColor, lineWidth: 2)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: size == .Large ? 12 : size == .Medium ? 9 : 8)
                )
                
                if !label.isEmpty || !caption.isEmpty {
                    VStack(alignment:.leading, spacing:0) {
                        
                        if !label.isEmpty {
                            Text(label)
                                .xelaButtonMedium()
                                .foregroundColor(labelColor)
                        }
                        
                        if !caption.isEmpty {
                            Text(caption)
                                .xelaCaption()
                                .foregroundColor(captionColor)
                        }
                    }
                }
                
                Spacer()
                if !value.isEmpty {
                    
                    Text(value)
                        .xelaButtonSmall()
                        .foregroundColor(valueColor)
                }
            }
        }
        .disabled(disabled)
        .opacity(disabled ? 0.48 : 1)
        .onHover { over in
            if !disabled {
                hover = over
            }
        }
        
        
        
    }
    
    func getSize() -> CGFloat {
        if size == .Large {
            return 32
        }
        
        if size == .Medium {
            return 24
        }
        
        return 20
    }
    
}
