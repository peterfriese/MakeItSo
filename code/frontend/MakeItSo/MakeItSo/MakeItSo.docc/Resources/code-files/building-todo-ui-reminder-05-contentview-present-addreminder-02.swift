import SwiftUI

struct ContentView: View {
  @State
  private var reminders = Reminder.samples

  @State
  private var isAddReminderDialogPresented = false

  private func presentAddReminderView() {
    isAddReminderDialogPresented.toggle()
  }

  var body: some View {
    List($reminders) { $reminder in
      HStack {
        Image(systemName: reminder.completed
              ? "largecircle.fill.circle"
              : "circle")
          .imageScale(.large)
          .foregroundColor(.accentColor)
          .onTapGesture {
            reminder.completed.toggle()
          }
        Text(reminder.title)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
