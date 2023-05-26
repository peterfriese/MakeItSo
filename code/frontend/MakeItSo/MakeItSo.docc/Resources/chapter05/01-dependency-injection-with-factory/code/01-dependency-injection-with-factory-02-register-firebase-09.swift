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

  public var firestore: Factory<Firestore> {
    Factory(self) {
    }.singleton
  }
}
