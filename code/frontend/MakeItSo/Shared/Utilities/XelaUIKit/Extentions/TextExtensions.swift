//
//  TextExtensions.swift
//  XelaExampleApp
//
//  Created by Sherhan on 31.07.2021.
//

import SwiftUI

extension Text {
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 60` and `bold`
     */
    func xelaTitle1() -> Text {
        self
            .font(.system(size: 60))
            .bold()
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 48` and `bold`
     */
    func xelaTitle2() -> Text {
        self
            .font(.system(size: 48))
            .bold()
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 34` and `black`
     */
    func xelaTitle3() -> Text {
        self
            .font(.system(size: 34))
            .fontWeight(.black)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 24` and `bold`
     */
    func xelaHeadline() -> Text {
        self
            .font(.system(size: 24))
            .fontWeight(.bold)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 18` and `bold`
     */
    func xelaSubheadline() -> Text {
        self
            .font(.system(size: 18))
            .fontWeight(.bold)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 16` and `regular`
     */
    func xelaBody() -> Text {
        self
            .font(.system(size: 16))
            .fontWeight(.regular)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 16` and `semibold`
     */
    func xelaBodyBold() -> Text {
        self
            .font(.system(size: 16))
            .fontWeight(.semibold)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 14` and `regular`
     */
    func xelaSmallBody() -> Text {
        self
            .font(.system(size: 14))
            .fontWeight(.regular)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 14` and `bold`
     */
    func xelaSmallBodyBold() -> Text {
        self
            .font(.system(size: 14))
            .fontWeight(.bold)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 12` and `semibold`
     */
    func xelaCaption() -> Text {
        self
            .font(.system(size: 12))
            .fontWeight(.semibold)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 16` and `semibold`
     */
    func xelaButtonLarge() -> Text {
        self
            .font(.system(size: 16))
            .fontWeight(.semibold)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 14` and `bold`
     */
    func xelaButtonMedium() -> Text {
        self
            .font(.system(size: 14))
            .fontWeight(.bold)
    }
    
    /**
     Modify the Text.

     - Returns: A new `Text` with `font size 12` and `bold`
     */
    func xelaButtonSmall() -> Text {
        self
            .font(.system(size: 12))
            .fontWeight(.bold)
    }
}
