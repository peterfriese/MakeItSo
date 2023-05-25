import Foundation

class RemindersListViewModel: ObservableObject {
  @Published
  var reminders = Reminder.samples

  func addReminder(_ reminder: Reminder) {
    reminders.append(reminder)
  }

}
