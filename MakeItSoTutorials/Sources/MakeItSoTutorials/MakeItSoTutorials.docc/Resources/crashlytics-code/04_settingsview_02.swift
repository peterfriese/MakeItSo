import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = SettingsViewModel()
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          NavigationLink(destination: UserProfileView()) {
            Label("Account", systemImage: "person.crop.circle")
          }
        }
        #if DEBUG
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
