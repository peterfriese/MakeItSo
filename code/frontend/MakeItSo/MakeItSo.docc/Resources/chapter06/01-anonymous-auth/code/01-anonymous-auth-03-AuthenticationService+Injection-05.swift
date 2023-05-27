import Foundation
import Factory

extension Container {
  public var authenticationService: Factory<AuthenticationService> {
    self {
      AuthenticationService()
    }.singleton
  }
}
