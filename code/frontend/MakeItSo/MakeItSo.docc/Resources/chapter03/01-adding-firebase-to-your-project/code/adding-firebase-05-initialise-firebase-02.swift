import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}

@main
struct MakeItSoApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        RemindersListView()
          .navigationTitle("Reminders")
      }
    }
  }
}