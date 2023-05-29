// MARK: - Sign in with Apple

extension AuthenticationViewModel {
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    authenticationService.handleSignInWithAppleRequest(request)
  }

  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async -> Bool {
    return await authenticationService.handleSignInWithAppleCompletion(withAccountLinking: true, result)
  }
}