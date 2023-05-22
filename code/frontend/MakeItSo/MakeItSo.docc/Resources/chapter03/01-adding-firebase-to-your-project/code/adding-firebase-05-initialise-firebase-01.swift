import SwiftUI
import FirebaseCore

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
