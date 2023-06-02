import SwiftUI

struct RemindersListRowView: View {
  @Binding
  var reminder: Reminder

  var body: some View {
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
}

struct RemindersListRowView_Previews: PreviewProvider {

  static var previews: some View {
    RemindersListRowView(reminder: .constant(Reminder.samples[0]))
  }
}