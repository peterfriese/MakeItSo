import Foundation
import Factory
import FirebaseAuth
import AuthenticationServices

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

// MARK: - Sign in with Apple

extension AuthenticationService {
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    do {
      let nonce = try CryptoUtils.randomNonceString()
    }
    catch {
      print("Error when creating a nonce: \(error.localizedDescription)")
    }
  }
}
