import SwiftUI
import Resolver
import FirebaseCore
import AuthenticationServices
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
  @LazyInjected var authenticationService: AuthenticationService
  @LazyInjected var configurationService: ConfigurationService
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    configurationService.fetchConfigurationData()
    authenticationService.signIn()
    return true
  }
}

@main
struct MakeItSoApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      TodosListView()
    }
  }
}
