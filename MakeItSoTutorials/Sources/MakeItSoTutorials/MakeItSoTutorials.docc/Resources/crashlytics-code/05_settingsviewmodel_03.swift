import Foundation
import FirebaseAuth
import Resolver

class SettingsViewModel: ObservableObject {
  @LazyInjected private var authenticationService: AuthenticationService
  
  @Published var user: User?
  @Published var isAnonymous = true
  @Published var displayName: String = ""
  @Published var authenticationState: AuthenticationState = .unauthenticated
  
  init() {
    authenticationService
      .$user
      .assign(to: &$user)
    
    $user
      .compactMap { $0?.isAnonymous }
      .assign(to: &$isAnonymous)
    
    authenticationService
      .$displayName
      .assign(to: &$displayName)
    
    authenticationService
      .$authenticationState
      .assign(to: &$authenticationState)
  }
  
  func signOut() {
    do {
      try authenticationService.signOut()
    }
    catch {
      print(error)
    }
  }
  
  #if DEBUG
  func crash() {
    fatalError("This is a forced crash.")
  }
  #endif
}
