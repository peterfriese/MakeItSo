//
//  XelaStepItem.swift
//  XelaExampleApp
//
//  Created by Sherhan on 04.08.2021.
//

import SwiftUI

struct XelaStepItem: Identifiable {
    
    
    public var id: Int
    public var title:String
    public var caption:String
    public var state:XelaStepsState


    init(id:Int, title:String = "", caption:String = "", state:XelaStepsState = .Default) {
        self.id = id
        self.title = title
        self.caption = caption
        self.state = state
    }
}

