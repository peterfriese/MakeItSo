import Foundation
import FirebaseFirestoreSwift

struct Reminder: Identifiable, Codable {
  @DocumentID
  var id: String?
  var title: String
  var isCompleted = false
  var userId: String? = nil
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
