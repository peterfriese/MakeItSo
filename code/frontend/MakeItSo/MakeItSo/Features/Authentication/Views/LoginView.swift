//
//  LoginView.swift
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
import Combine
import FirebaseAnalyticsSwift
import AuthenticationServices

private enum FocusableField: Hashable {
  case email
  case password
}

struct LoginView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?

  private func signInWithEmailPassword() {
    Task {
      await viewModel.signInWithEmailPassword()
    }
  }
  
  var body: some View {
    VStack {
      Image("Login")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(minHeight: 300, maxHeight: 400)
      Text("Login")
        .font(.largeTitle)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack {
        Image(systemName: "at")
        TextField("Email", text: $viewModel.email)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .focused($focus, equals: .email)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .password
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 4)

      HStack {
        Image(systemName: "lock")
        SecureField("Password", text: $viewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.go)
          .onSubmit {
            signInWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)

      if !viewModel.errorMessage.isEmpty {
        VStack {
          Text(viewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }

      Button(action: signInWithEmailPassword) {
        if viewModel.authenticationState != .authenticating {
          Text("Login")
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
        else {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
      }
      .disabled(!viewModel.isValid)
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)

      HStack {
        VStack { Divider() }
        Text("or")
        VStack { Divider() }
      }

      SignInWithAppleButton(.signIn) { request in
        viewModel.handleSignInWithAppleRequest(request, withStrategy: .link)
      } onCompletion: { result in
        viewModel.handleSignInWithAppleCompletion(result)
      }
      .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
      .frame(maxWidth: .infinity, minHeight: 50)
      .cornerRadius(8)

      // IDEA: implement a FirebaseSiwA button with a flexible layout
//      Button(action: { }) {
//        Text("Sign in with Apple")
//          .padding(.vertical, 8)
//          .frame(maxWidth: .infinity)
//          .background(alignment: .leading) {
//            Image(systemName: "applelogo")
//              .frame(width: 30, alignment: .center)
//          }
//      }
//      .foregroundColor(.black)
//      .buttonStyle(.bordered)

      //      Button(action: { }) {
      //        Text("Sign in with Google")
      //          .padding(.vertical, 8)
      //          .frame(maxWidth: .infinity)
      //          .background(alignment: .leading) {
      //            Image("Google")
      //              .frame(width: 30, alignment: .center)
      //          }
      //      }
      //      .foregroundColor(.black)
      //      .buttonStyle(.bordered)

      HStack {
        Text("Don't have an account yet?")
        Button(action: { viewModel.switchFlow() }) {
          Text("Sign up")
            .fontWeight(.semibold)
            .foregroundColor(.blue)
        }
      }
      .padding([.top, .bottom], 50)

    }
    .listStyle(.plain)
    .padding()
    .analyticsScreen(name: "\(Self.self)")
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LoginView()
      LoginView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
