import Foundation
import Factory
import FirebaseAuth

public class AuthenticationService {
  @Injected(\.auth) private var auth
  @Published var user: User?

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  init() {
    registerAuthStateHandler()
    signInAnonymously()
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
      print("Nobody is signed in. Trying to sign in anonymously.")
      auth.signInAnonymously()
    }
    else {
      if let user = auth.currentUser {
        print("Someone is signed in with \(user.providerID) and user ID \(user.uid)")
      }
    }
  }
}
