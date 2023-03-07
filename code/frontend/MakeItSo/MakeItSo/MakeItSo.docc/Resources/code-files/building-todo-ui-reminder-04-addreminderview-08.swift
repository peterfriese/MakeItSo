import SwiftUI

struct AddReminderView: View {
  @State
  private var reminder = Reminder(title: "")

  var completion: (_ reminder: Reminder) -> Void

  private func commit() {
    completion(reminder)
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
