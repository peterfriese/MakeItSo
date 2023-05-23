import Foundation

public class RemindersRepository: ObservableObject {

  @Published
  var reminders = [Reminder]()

  func addReminder(_ reminder: Reminder) throws {
  }

}
