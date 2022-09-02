//
//  FirebaseSignInWithAppleButton.swift
//  Favourites
//
//  Created by Peter Friese on 09.07.22.
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
import AuthenticationServices

struct FirebaseSignInWithAppleButton: View {
  var body: some View {
    Button(action: { }) {
      Text("Sign in with Apple")
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(alignment: .leading) {
          Image(systemName: "applelogo")
            .frame(width: 30, alignment: .center)
        }
    }
    .foregroundColor(.black)
    .buttonStyle(.bordered)

  }
}

struct FirebaseSignInWithAppleButton_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      FirebaseSignInWithAppleButton()

      SignInWithAppleButton(onRequest: { request in
        //
      }, onCompletion: { result in
        //
      })
      .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
    }
    .padding()
  }
}
