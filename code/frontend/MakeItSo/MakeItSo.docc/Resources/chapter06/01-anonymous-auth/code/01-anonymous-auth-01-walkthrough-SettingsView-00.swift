import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel = SettingsViewModel()
  @State var isShowSignUpDialogPresented = false

  var body: some View {
    NavigationStack {
      Form {
        Section {
        }
        Section {
          if viewModel.isGuestUser {
          }
          else {
          }
        } footer: {
          HStack {
            Spacer()
            Text(viewModel.loggedInAs)
            Spacer()
          }
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
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
