import SwiftUI

struct ContentView: View {
  @State
  private var reminders = Reminder.samples

  var body: some View {
    List(reminders) { reminder in
      HStack {
        Image(systemName: "circle")
          .imageScale(.large)
          .foregroundColor(.accentColor)
        Text("Hello, world!")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
