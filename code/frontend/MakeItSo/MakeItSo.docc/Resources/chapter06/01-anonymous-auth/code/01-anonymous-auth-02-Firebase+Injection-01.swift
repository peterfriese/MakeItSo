import Foundation
import Factory
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Container {

  /// Determines whether to use the Firebase Local Emulator Suite.
  /// To use the local emulator, go to the active scheme, and add `-useEmulator YES`
  /// to the _Arguments Passed On Launch_ section.
  public var useEmulator: Factory<Bool> {
    Factory(self) {
      let value =  UserDefaults.standard.bool(forKey: "useEmulator")
      print("Using the emulator: \(value == true ? "YES" : "NO")")
      return value
    }.singleton
  }

  public var auth: Factory<Auth> {
    Factory(self) {
      var environment = ""
      if Container.shared.useEmulator() {
        let host = "localhost"
        let port = 9099
        environment = "to use the local emulator on \(host):\(port)"
        Auth.auth().useEmulator(withHost: host, port: port)
      }
      else {
        environment = "to use the Firebase backend"
      }
      print("Configuring Firebase Auth \(environment).")
      return Auth.auth()
    }.singleton
  }

  public var firestore: Factory<Firestore> {
    Factory(self) {
      var environment = ""
      if Container.shared.useEmulator() {
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.cacheSettings = MemoryCacheSettings()
        settings.isSSLEnabled = false
        environment = "to use the local emulator on \(settings.host)"

        Firestore.firestore().settings = settings
      }
      else {
        environment = "to use the Firebase backend"
      }
      print("Configuring Cloud Firestore \(environment).")
      return Firestore.firestore()
    }.singleton
  }
}
