//
//  MakeItSoApp.swift
//  MakeItSo
//
//  Created by Peter Friese on 25.10.21.
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
import Firebase
import Resolver

@main
struct MakeItSoApp: App {
  @LazyInjected
  var authenticationService: AuthenticationService
  
  @StateObject
  var viewModel = RemindersListViewModel(reminders: Reminder.samples)
  
  init() {
    let navBarAppearance = UINavigationBarAppearance()
    
    navBarAppearance.largeTitleTextAttributes[.font] = UIFont.roundedLargeTitle()
    navBarAppearance.largeTitleTextAttributes[.foregroundColor] = UIColor(Color.accentColor)
    navBarAppearance.titleTextAttributes[.font] = UIFont.roundedHeadline()
    // Purposefully don't set the foreground color for normal text nav bar -
    // in Reminders.app, this isn't tinted as well!
    // navBarAppearance.titleTextAttributes[.foregroundColor] = foregroundColor
    
    UINavigationBar.appearance().standardAppearance = navBarAppearance
    
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    FirebaseApp.configure()
    authenticationService.signIn()
  }

  var body: some Scene {
    WindowGroup {
      NavigationView {
        RemindersListView()
          .font(.system(.body, design: .rounded))
          .environmentObject(viewModel)
      }
      .accentColor(.red)
    }
  }
}
