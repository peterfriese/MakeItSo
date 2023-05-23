import Foundation

public class RemindersRepository: ObservableObject {

  @Published
  var reminders = [Reminder]()

}
