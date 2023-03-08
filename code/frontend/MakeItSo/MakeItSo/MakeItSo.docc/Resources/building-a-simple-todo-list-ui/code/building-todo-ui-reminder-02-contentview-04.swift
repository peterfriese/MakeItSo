import SwiftUI

struct ContentView: View {
  var body: some View {
    HStack {
      Image(systemName: "circle")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
