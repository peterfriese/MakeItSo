//
//	Appearance.swift
//  MakeItSo (iOS)
//
//  Created by Peter Friese on 06.12.21.
//  Copyright © 2021 Google LLC. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI

extension UIFontDescriptor {
  static func largeTitle() -> UIFontDescriptor? {
    UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withSymbolicTraits(.traitBold)
  }
  
  static func headline() -> UIFontDescriptor? {
    UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).withSymbolicTraits(.traitBold)
  }
  
  func rounded() -> UIFontDescriptor? {
    self.withDesign(.rounded)
  }
}


// see https://gist.github.com/darrensapalo/bd6dddab6a70ae0a2d6cf8ac5aeb6b1a for more
extension UIFont {
  static func roundedLargeTitle() -> UIFont? {
    guard let descriptor = UIFontDescriptor.largeTitle()?.rounded() else { return nil }
    return UIFont(descriptor: descriptor, size: 0)
  }
  
  static func roundedHeadline() -> UIFont? {
    guard let descriptor = UIFontDescriptor.headline()?.rounded() else { return nil }
    return UIFont(descriptor: descriptor, size: 0)
  }
}

extension View {
}

