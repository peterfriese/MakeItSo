import SwiftUI

struct AddReminderView: View {
  @State
  private var reminder = Reminder(title: "")

  var onCommit: (_ reminder: Reminder) -> Void

  private func commit() {
    onCommit(reminder)
  }

  var body: some View {
    NavigationStack {
      Form {
        TextField("Title", text: $reminder.title)
      }
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button(action: commit) {
            Text("Add")
          }
        }
      }
    }
  }
}

struct AddReminderView_Previews: PreviewProvider {
  static var previews: some View {
    AddReminderView { reminder in
      print("You added a new reminder titled \(reminder.title)")
    }
  }
}
