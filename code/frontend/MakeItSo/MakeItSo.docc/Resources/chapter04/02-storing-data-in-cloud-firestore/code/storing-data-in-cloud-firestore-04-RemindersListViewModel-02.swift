import Foundation

class RemindersListViewModel: ObservableObject {
  @Published
  var reminders = Reminder.samples

  private var remindersRepository: RemindersRepository =  RemindersRepository()

  func addReminder(_ reminder: Reminder) {
    remindersRepository.addReminder(reminder)
  }

  func toggleCompleted(_ reminder: Reminder) {
    if let index = reminders.firstIndex(where: { $0.id == reminder.id} ) {
      reminders[index].isCompleted.toggle()
    }
  }
}
