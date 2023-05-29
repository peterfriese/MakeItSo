@MainActor
func handleSignInWithAppleCompletion(withAccountLinking: Bool = false, _ result: Result<ASAuthorization, Error>) async -> Bool {
  if case .failure(let failure) = result {
    errorMessage = failure.localizedDescription
    return false
  }
  else if case .success(let authorization) = result {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: a login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identify token.")
        return false
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
        return false
      }

      let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                      rawNonce: nonce,
                                                      fullName: appleIDCredential.fullName)

      do {
        if withAccountLinking {
          let authResult = try await user?.link(with: credential)
        }
        else {
          try await auth.signIn(with: credential)
        }
        return true
      }
      catch {
        print("Error authenticating: \(error.localizedDescription)")
        return false
      }
    }
  }
  return false
}