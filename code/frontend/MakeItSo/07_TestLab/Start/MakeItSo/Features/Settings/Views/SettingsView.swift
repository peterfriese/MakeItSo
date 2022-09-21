//
//  SettingsView.swift
//  MakeItSo
//
//  Created by Peter Friese on 27.07.22.
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

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = SettingsViewModel()
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          NavigationLink(destination: UserProfileView()) {
            Label("Account", systemImage: "person.crop.circle")
          }
        }
        #if DEBUG
        Section {
          Button(action: viewModel.crash) {
            Label("Force crash", systemImage: "bolt.fill")
          }
        }
        #endif
        Section {
          Label("Help & Feedback", systemImage: "questionmark.circle")
          Label("About", systemImage: "info.circle")
          Label("What's New", systemImage: "lightbulb")
        }
        AuthenticationSection()
          .environmentObject(viewModel)
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { dismiss() }) {
            Text("Done")
          }
        }
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

struct AuthenticationSection: View {
  @EnvironmentObject private var viewModel: SettingsViewModel
  @State private var presentingAuthenticationView = false
  
  var body: some View {
    Section {
      Button(action: {
        if viewModel.isAnonymous {
          presentingAuthenticationView.toggle()
        }
        else {
          viewModel.signOut()
        }
      }) {
        HStack {
          Spacer()
          Text("Log \(viewModel.isAnonymous ? "in" : "out")")
          Spacer()
        }
      }
    } footer: {
      HStack {
        Spacer()
        Text(viewModel.isAnonymous ? "You're using the app as a guest user." : "Logged in as: \(viewModel.displayName)")
        Spacer()
      }
    }
    .sheet(isPresented: $presentingAuthenticationView) {
      AuthenticationView()
    }
  }
}
