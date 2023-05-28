import Foundation
import Combine
import Factory
import FirebaseCore
import FirebaseAuth

// (code ommitted for brevity)

@MainActor
class AuthenticationViewModel: ObservableObject {
  @Injected(\.authenticationService)
  var authenticationService

  // (code ommitted for brevity)
}

