import Foundation
import Combine
import Factory
import FirebaseCore
import FirebaseAuth
import AuthenticationServices

// (code ommitted for brevity)

@MainActor
class AuthenticationViewModel: ObservableObject {
  @Injected(\.authenticationService)
  var authenticationService

  // (code ommitted for brevity)
}

// MARK: - Sign in with Apple

extension AuthenticationViewModel {
}
