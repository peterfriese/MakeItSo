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

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([[.banner, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler:
                                @escaping () -> Void) {
    completionHandler()
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(error)
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
}
