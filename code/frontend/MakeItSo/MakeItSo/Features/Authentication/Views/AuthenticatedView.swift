//
//  AuthenticatedView.swift
//  Favourites
//
//  Created by Peter Friese on 08.07.2022
//  Copyright © 2022 Google LLC. All rights reserved.
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
import AuthenticationServices

// see https://michael-ginn.medium.com/creating-optional-viewbuilder-parameters-in-swiftui-views-a0d4e3e1a0ae
extension AuthenticatedView where Unauthenticated == EmptyView {
  init(@ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = nil
    self.content = content
  }
}

struct AuthenticatedView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
  @StateObject private var viewModel = AuthenticationViewModel()
  @State private var presentingLoginScreen = false
  @State private var presentingProfileScreen = false

  var unauthenticated: Unauthenticated?
  @ViewBuilder var content: () -> Content

  public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = unauthenticated
    self.content = content
  }

  public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = unauthenticated()
    self.content = content
  }


  var body: some View {
    switch viewModel.authenticationState {
    case .unauthenticated, .authenticating:
      VStack {
        if let unauthenticated = unauthenticated {
          unauthenticated
        }
        else {
          Text("You're not logged in.")
        }
        Button("Tap here to log in") {
          viewModel.reset()
          presentingLoginScreen.toggle()
        }
      }
      .sheet(isPresented: $presentingLoginScreen) {
        AuthenticationView()
          .environmentObject(viewModel)
      }
//    case .authenticating:
//      Text("Logging in, please wait...")
    case .authenticated:
      VStack {
        content()
        Text("You're logged in as \(viewModel.displayName).")
        Button("Tap here to view your profile") {
          presentingProfileScreen.toggle()
        }
      }
      .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)) { event in
        viewModel.signOut()
        if let userInfo = event.userInfo, let info = userInfo["info"] {
          print(info)
        }
      }
      .sheet(isPresented: $presentingProfileScreen) {
        NavigationView {
          UserProfileView()
            .environmentObject(viewModel)
        }
      }
    }
  }
}

struct AuthenticatedView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticatedView {
      Text("You're signed in.")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.yellow)
    }
  }
}
