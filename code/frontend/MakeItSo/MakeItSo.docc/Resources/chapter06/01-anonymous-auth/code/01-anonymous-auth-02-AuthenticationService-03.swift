import Foundation
import Factory
import FirebaseAuth

public class AuthenticationService {
  @Injected(\.auth) private var auth
  @Published var user: User?
}