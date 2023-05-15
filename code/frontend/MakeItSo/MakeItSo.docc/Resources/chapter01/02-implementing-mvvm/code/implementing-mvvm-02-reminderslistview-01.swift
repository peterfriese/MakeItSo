import SwiftUI

struct RemindersListView: View {
  @State
  private var reminders = Reminder.samples

  @StateObject
  private var viewModel = RemindersListViewModel()

  @State
  private var isAddReminderDialogPresented = false

  private func presentAddReminderView() {
    isAddReminderDialogPresented.toggle()
  }

  var body: some View {
    List($reminders) { $reminder in
      HStack {
        Image(systemName: reminder.isCompleted
              ? "largecircle.fill.circle"
              : "circle")
          .imageScale(.large)
          .foregroundColor(.accentColor)
          .onTapGesture {
            reminder.isCompleted.toggle()
          }
        Text(reminder.title)
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .bottomBar) {
        Button(action: presentAddReminderView) {
          HStack {
            Image(systemName: "plus.circle.fill")
            Text("New Reminder")
          }
        }
        Spacer()
      }
    }
    .sheet(isPresented: $isAddReminderDialogPresented) {
      AddReminderView { reminder in
        reminders.append(reminder)
      }
    }
  }
}
