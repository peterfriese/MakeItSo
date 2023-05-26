import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

//    let useEmulator = UserDefaults.standard.bool(forKey: "useEmulator")
//    if useEmulator {
//      let settings = Firestore.firestore().settings
//      settings.host = "localhost:8080"
//      settings.isSSLEnabled = false
//      Firestore.firestore().settings = settings
//
//      Auth.auth().useEmulator(withHost: "localhost", port: 9099)
//    }

    return true
  }
}

@main
struct MakeItSoApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        RemindersListView()
          .navigationTitle("Reminders")
      }
    }
  }
}
