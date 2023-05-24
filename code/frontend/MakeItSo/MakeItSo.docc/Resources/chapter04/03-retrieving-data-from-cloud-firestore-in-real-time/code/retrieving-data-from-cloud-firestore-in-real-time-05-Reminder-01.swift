import Foundation
import FirebaseFirestoreSwift

struct Reminder: Identifiable, Codable {
  @DocumentID
  var id: String?
  var title: String
  var isCompleted = false
}

extension Reminder {
  static let collectionName = "reminders"
}

extension Reminder {
  static let samples = [
    Reminder(title: "Build sample app", isCompleted: true),
    Reminder(title: "Create tutorial"),
    Reminder(title: "???"),
    Reminder(title: "PROFIT!"),
  ]
}
