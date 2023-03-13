import SwiftUI

struct ContentView: View {
  @State
  private var reminders = Reminder.samples

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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
