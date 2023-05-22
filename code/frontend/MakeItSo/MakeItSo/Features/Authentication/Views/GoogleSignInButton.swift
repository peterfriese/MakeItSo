//
// GoogleSignInButton.swift
// MakeItSo
//
// Created by Peter Friese on 19.05.23.
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

enum GoogleSignInButtonLabel: String {
  case signIn = "Sign in with Google"
  case `continue` = "Continue with Google"
  case signUp = "Sign up with Google"
}

struct GoogleSignInButton: View {
  @Environment(\.colorScheme)
  private var colorScheme

  var label = GoogleSignInButtonLabel.continue
  var action: () -> Void

  init(_ label: GoogleSignInButtonLabel = .continue, action: @escaping () -> Void) {
    self.label = label
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      HStack(spacing: 2) {
        Image("Google")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, alignment: .center)
        Text(label.rawValue)
          .bold()
          .padding(.vertical, 8)
      }
      .frame(maxWidth: .infinity)
    }
    .foregroundColor(colorScheme == .dark ? .black : .white)
    .background(colorScheme == .dark ? .white : .black)
    .cornerRadius(8)
    .buttonStyle(.bordered)
  }
}

struct GoogleSignInButton_Previews: PreviewProvider {
  static var previews: some View {
    GoogleSignInButton {
      print("User clicked on sign in")
    }
  }
}
