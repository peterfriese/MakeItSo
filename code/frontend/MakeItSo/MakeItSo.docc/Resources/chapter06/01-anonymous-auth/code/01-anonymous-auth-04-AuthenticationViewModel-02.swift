import Foundation
import Combine
import Factory
import FirebaseCore
import FirebaseAuth

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
  @Injected(\.authenticationService)
  var authenticationService

  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""

  @Published var flow: AuthenticationFlow = .signUp
  @Published var isOtherAuthOptionsVisible = false

  @Published var isValid = false
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var displayName = ""

  @Published var isGuestUser = false
  @Published var isVerified = false

  private var cancellables = Set<AnyCancellable>()

  init(flow: AuthenticationFlow = .signUp) {
    self.flow = flow

    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
        ? !(email.isEmpty || password.isEmpty)
        : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)

    $user
      .compactMap { user in
        user?.isAnonymous
      }
      .assign(to: &$isGuestUser)

    $user
      .compactMap { user in
        user?.isEmailVerified
      }
      .assign(to: &$isVerified)

    $user
      .compactMap { user in
        user?.displayName ?? user?.email ?? ""
      }
      .assign(to: &$displayName)
  }

  func switchFlow() {
    flow = flow == .login ? .signUp : .login
    errorMessage = ""
  }

  func reset() {
    flow = .login
    email = ""
    password = ""
    confirmPassword = ""
  }


  // MARK: - Account Deletion
  func deleteAccount() async -> Bool {
    return await authenticationService.deleteAccount()
  }

  // MARK: - Signing out
  func signOut() {
    authenticationService.signOut()
  }
}
