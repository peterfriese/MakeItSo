import Foundation
import Factory
import FirebaseAuth
import AuthenticationServices

public class AuthenticationService {
  @Injected(\.auth) private var auth
  @Published var user: User?

  @Published var errorMessage = ""
  private var currentNonce: String?

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
  @MainActor
  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async -> Bool {
  }

  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    do {
      let nonce = try CryptoUtils.randomNonceString()
      currentNonce = nonce
      request.nonce = CryptoUtils.sha256(nonce)
    }
    catch {
      print("Error when creating a nonce: \(error.localizedDescription)")
    }
  }
}
