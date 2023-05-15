import Foundation

class RemindersListViewModel: ObservableObject {
  @Published
  var reminders = Reminder.samples
}
