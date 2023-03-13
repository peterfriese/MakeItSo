import SwiftUI

struct AddReminderView: View {
  @State
  private var reminder = Reminder(title: "")

  var body: some View {
    NavigationStack {
      Form {
        TextField("Title", text: $reminder.title)
      }
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button(action: {}) {
            Text("Add")
          }
        }
      }
    }
  }
}

struct AddReminderView_Previews: PreviewProvider {
  static var previews: some View {
    AddReminderView()
  }
}
