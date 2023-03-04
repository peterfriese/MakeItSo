//
//  XelaStepsItems.swift
//  XelaExampleApp
//
//  Created by Sherhan on 04.08.2021.
//

import SwiftUI

class XelaStepsItems: ObservableObject {
    @Published var items:[XelaStepItem]
    
    init(items:[XelaStepItem]) {
        self.items = items
    }
    
    
}
