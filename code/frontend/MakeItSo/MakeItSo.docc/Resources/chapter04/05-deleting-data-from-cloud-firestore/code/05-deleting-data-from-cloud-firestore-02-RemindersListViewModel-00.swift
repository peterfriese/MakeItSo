import Foundation
import Combine

class RemindersListViewModel: ObservableObject {
  @Published
  var reminders = [Reminder]()

  @Published
  var errorMessage: String?

  private var remindersRepository: RemindersRepository =  RemindersRepository()

  // (code ommitted for brevity)

  func updateReminder(_ reminder: Reminder) {
    do {
      try remindersRepository.updateReminder(reminder)
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func setCompleted(_ reminder: Reminder, isCompleted: Bool) {
    var editedReminder = reminder
    editedReminder.isCompleted = isCompleted
    updateReminder(editedReminder)
  }

}
