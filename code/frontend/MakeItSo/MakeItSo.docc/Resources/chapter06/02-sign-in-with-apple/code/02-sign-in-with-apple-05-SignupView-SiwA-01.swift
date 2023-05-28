import SwiftUI
import Combine
import AuthenticationServices
import FirebaseAnalyticsSwift

private enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

struct SignupView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?

  // (code ommitted for brevity)

  var body: some View {
    VStack {
      
      // (code ommitted for brevity)

      GoogleSignInButton(.signUp) {
        // sign in with Google
      }

      SignInWithAppleButton(.signUp) { request in
        viewModel.handleSignInWithAppleRequest(request)
      } onCompletion: { result in
        // handle completion
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


struct SignupView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SignupView()
      SignupView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
