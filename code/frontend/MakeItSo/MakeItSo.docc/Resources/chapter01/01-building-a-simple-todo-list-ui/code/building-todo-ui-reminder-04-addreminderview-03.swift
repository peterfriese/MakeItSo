import SwiftUI

struct AddReminderView: View {
  @State
  private var reminder = Reminder(title: "")

  var body: some View {
    Form {
      Text("Hello, World!")
    }
  }
}

struct AddReminderView_Previews: PreviewProvider {
  static var previews: some View {
    AddReminderView()
  }
}
