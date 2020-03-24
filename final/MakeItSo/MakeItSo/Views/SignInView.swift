//
//  SignInView.swift
//  MakeItSo
//
//  Created by Peter Friese on 14/02/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI
import Firebase
import AuthenticationServices
import CryptoKit

struct SignInView: View {
  @Environment(\.window) var window: UIWindow?
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  @State var signInHandler: SignInWithAppleCoordinator?
  
  var body: some View {
    VStack {
      Image("Logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.horizontal, 100)
        .padding(.top, 100)
        .padding(.bottom, 50)
      
      
      HStack {
        Text("Welcome to")
          .font(.title)
        
        Text("Make It So")
          .font(.title)
          .fontWeight(.semibold)
      }
      
      Text("Create an account to save your tasks and access them anywhere. It's free. \n Forever.")
        .font(.headline)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .padding(.top, 20)
      
      Spacer()
      
      SignInWithAppleButton()
        .frame(width: 280, height: 45)
        .onTapGesture {
          self.signInWithAppleButtonTapped()
      }
      
      // other buttons will go here
      
      Divider()
        .padding(.horizontal, 15.0)
        .padding(.top, 20.0)
        .padding(.bottom, 15.0)

      
      Text("By using Make It So you agree to our Terms of Use and Service Policy")
        .multilineTextAlignment(.center)
    }
  }
  
  func signInWithAppleButtonTapped() {
    signInHandler = SignInWithAppleCoordinator(window: self.window)
    signInHandler?.link { (user) in
      print("User signed in. UID: \(user.uid), email: \(user.email ?? "(empty)")")
      self.presentationMode.wrappedValue.dismiss()
    }
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView()
  }
}
