//
//  SettingsView.swift
//  MakeItSo
//
//  Created by Peter Friese on 19/02/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  @ObservedObject var settingsViewModel = SettingsViewModel()
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    NavigationView {
      VStack {
        Image("Logo")
          .resizable()
          .frame(width: 100, height: 100)
          .aspectRatio(contentMode: .fit)
          .padding(.horizontal, 100)
          .padding(.top, 20)

        Text("Thanks for using")
          .font(.title)

        Text("Make It So")
          .font(.title)
          .fontWeight(.semibold)
        
        Form {
          Section {
            HStack {
              Image(systemName: "checkmark.circle")
              Text("App Icon")
              Spacer()
              Text("Plain")
            }
          }
          
          Section {
            HStack {
              Image("Siri")
                .resizable()
                .frame(width: 17, height: 17)
              Text("Siri")
            }
          }
          
          Section {
            HStack {
              Image(systemName: "questionmark.circle")
              Text("Help & Feedback")
            }
            NavigationLink(destination: Text("About!") ) {
              HStack {
                Image(systemName: "info.circle")
                Text("About")
              }
            }
          }
          
          AccountSection(settingsViewModel: self.settingsViewModel)
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .navigationBarItems(trailing:
          Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Text("Done")
        })
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

struct AccountSection: View {
  @ObservedObject var settingsViewModel: SettingsViewModel
  @State private var showSignInView = false
  
  var body: some View {
    Section(footer: footer) {
      button
    }
  }
  
  var footer: some View {
    HStack {
      Spacer()
      if settingsViewModel.isAnonymous {
        Text("You're not logged in.")
      }
      else {
        VStack {
          Text("Thanks for using Make It So, \(self.settingsViewModel.displayName)!")
          Text("Logged in as \(self.settingsViewModel.email)")
        }
      }
      Spacer()
    }
  }
  
  var button: some View {
    VStack {
      if settingsViewModel.isAnonymous {
        Button(action: { self.login() }) {
          HStack {
            Spacer()
            Text("Login")
            Spacer()
          }
        }
      }
      else {
        Button(action: { self.logout() }) {
          HStack {
            Spacer()
            Text("Logout")
            Spacer()
          }
        }
      }
    }
    .sheet(isPresented: self.$showSignInView) {
      SignInView()
    }
  }
  
  func login() {
    self.showSignInView.toggle()
  }
  
  func logout() {
    self.settingsViewModel.logout()
  }
  
}
