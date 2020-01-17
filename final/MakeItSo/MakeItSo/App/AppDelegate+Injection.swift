//
//  AppDelegate+Injection.swift
//  MakeItSo
//
//  Created by Peter Friese on 14/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
//    register { TestDataTaskRepository() as TaskRepository }.scope(application)
    register { LocalTaskRepository() as TaskRepository }.scope(application)
  }
}
