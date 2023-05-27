import Foundation
import Factory
import FirebaseAuth

public class AuthenticationService {
  @Injected(\.auth) private var auth
  @Published var user: User?

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  init() {
    registerAuthStateHandler()
  }

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = auth.addStateDidChangeListener { auth, user in
        self.user = user
      }
    }
  }

}

// MARK: - Sign in anonymously

extension AuthenticationService {
  func signInAnonymously() {
    if auth.currentUser == nil {
    }
  }
}
