import SwiftUI
import Factory
import Combine
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var provider = ""
  @Published var displayName = ""
  @Published var email = ""

  @Published var isGuestUser = false
  @Published var isVerified = false

  init() {
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
        user?.displayName ?? "N/A"
      }
      .assign(to: &$displayName)

    $user
      .compactMap { user in
        user?.email ?? "N/A"
      }
      .assign(to: &$email)

    $user
      .compactMap { user in
        if let providerData = user?.providerData.first {
          return providerData.providerID
        }
        else {
          return user?.providerID
        }
      }
      .assign(to: &$provider)

  }

  func deleteAccount() async -> Bool {
    fatalError("Not implemented yet")
  }

  func signOut() {
    fatalError("Not implemented yet")
  }
}
