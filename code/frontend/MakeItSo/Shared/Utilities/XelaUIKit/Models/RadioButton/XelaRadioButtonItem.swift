//
//  XelaRadioButtonItem.swift
//  XelaExampleApp
//
//  Created by Sherhan on 02.08.2021.
//

import Foundation
struct XelaRadioButtonItem: Identifiable {
    public var id:String
    public var label:String
    public var caption:String
    public var value:String = ""
    public var state:XelaRadioButtonState = .Default
}
