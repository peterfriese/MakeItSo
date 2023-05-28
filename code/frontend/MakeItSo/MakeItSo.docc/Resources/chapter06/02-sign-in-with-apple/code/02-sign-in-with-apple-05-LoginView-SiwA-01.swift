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

  // (code ommitted for brevity)

  var body: some View {
    VStack {

      // (code ommitted for brevity)

      GoogleSignInButton(.signIn) {
        // sign in with Google
      }

      SignInWithAppleButton(.signIn) { request in
        viewModel.handleSignInWithAppleRequest(request)
      } onCompletion: { result in
      }
      .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
      .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
      .cornerRadius(8)

      // (code ommitted for brevity)
    }
    .padding()
    .analyticsScreen(name: "\(Self.self)")
  }
}

struct LoginView_Previews: PreviewProvider {
  struct Container: View {
    @StateObject var viewModel = AuthenticationViewModel(flow: .login)

    var body: some View {
      LoginView()
        .environmentObject(viewModel)
    }
  }

  static var previews: some View {
    Container()
  }
}
