import SwiftUI

struct RemindersListView: View {
  @StateObject
  private var viewModel = RemindersListViewModel()

  @State
  private var isAddReminderDialogPresented = false

  @State
  private var editableReminder: Reminder? = nil

  private func presentAddReminderView() {
    isAddReminderDialogPresented.toggle()
  }

  var body: some View {
    List($viewModel.reminders) { $reminder in
      RemindersListRowView(reminder: $reminder)
        .onChange(of: reminder.isCompleted) { newValue in
          viewModel.setCompleted(reminder, isCompleted: newValue)
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
      EditReminderDetailsView { reminder in
        viewModel.addReminder(reminder)
      }
    }
    .tint(.red)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      RemindersListView()
        .navigationTitle("Reminders")
    }
  }
}
