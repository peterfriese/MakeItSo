import SwiftUI

struct RemindersListView: View {
  @StateObject
  private var viewModel = RemindersListViewModel()

  @State
  private var isAddReminderDialogPresented = false

  private func presentAddReminderView() {
    isAddReminderDialogPresented.toggle()
  }

  var body: some View {
    List($viewModel.reminders) { $reminder in
      ExtractedView()
    }
    .toolbar {
      // (code ommitted for brevity)
    }
    // (code ommitted for brevity)
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

struct ExtractedView: View {
  var body: some View {
    HStack {
      Image(systemName: reminder.isCompleted
            ? "largecircle.fill.circle"
            : "circle")
      .imageScale(.large)
      .foregroundColor(.accentColor)
      .onTapGesture {
        viewModel.toggleCompleted(reminder)
      }
      Text(reminder.title)
    }
  }
}
