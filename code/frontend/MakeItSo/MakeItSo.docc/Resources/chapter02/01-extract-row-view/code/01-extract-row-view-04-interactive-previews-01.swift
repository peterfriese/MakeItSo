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
  struct Container: View {
    var body: some View {
    }
  }

  static var previews: some View {
    RemindersListRowView(reminder: .constant(Reminder.samples[0]))
  }
}