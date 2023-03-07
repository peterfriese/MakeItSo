import Foundation

struct Reminder {
  var title: String
  var completed = false
}

extension Reminder {
  static let samples = [
    Reminder(title: "Build sample app", completed: true),
    Reminder(title: "Create tutorial"),
    Reminder(title: "???"),
    Reminder(title: "PROFIT!"),
  ]
}
