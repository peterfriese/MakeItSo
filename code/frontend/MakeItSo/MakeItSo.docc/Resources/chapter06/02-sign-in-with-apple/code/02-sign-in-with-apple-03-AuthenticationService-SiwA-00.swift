import Foundation
import Factory
import FirebaseAuth

public class AuthenticationService {
  @Injected(\.auth) private var auth
  @Published var user: User?

  @Published var errorMessage = ""

  // (code ommitted for brevity)
}

// MARK: - Sign in anonymously

extension AuthenticationService {
  func signInAnonymously() {
  // (code ommitted for brevity)    
  }
}