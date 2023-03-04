//
//  OtherExtensions.swift
//  XelaExampleApp
//
//  Created by Sherhan on 01.08.2021.
//

import SwiftUI

extension View {
    /**
     Modify the Textfield.

     - Returns: `Textfield` with `placeholder`
     */
    func xelaPlaceholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder()
                .zIndex(-1)
                .disabled(true)
            self
        }
    }
}

extension Binding {
    /**
     Modify the Binding values.

     - Returns: A new `Binding<Value>` with handler
     */
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>, step:CGFloat) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        let newVal = (result / step).rounded() * step
        return newVal
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( XelaRoundedCorner(radius: radius, corners: corners) )
    }
}

extension Date {
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
