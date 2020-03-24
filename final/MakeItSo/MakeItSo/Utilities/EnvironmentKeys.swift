//
//  EnvironmentKeys.swift
//  MakeItSo
//
//  Created by Peter Friese on 14/02/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct WindowKey: EnvironmentKey {
  struct Value {
    weak var value: UIWindow?
  }
  
  static let defaultValue: Value = .init(value: nil)
}

extension EnvironmentValues {
  var window: UIWindow? {
    get { return self[WindowKey.self].value }
    set { self[WindowKey.self] = .init(value: newValue) }
  }
}

