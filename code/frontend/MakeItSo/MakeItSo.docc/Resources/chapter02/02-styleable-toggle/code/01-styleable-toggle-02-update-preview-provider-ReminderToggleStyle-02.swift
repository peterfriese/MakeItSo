import SwiftUI

struct ReminderToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Image(systemName: configuration.isOn
            ? "largecircle.fill.circle"
            : "circle")
        .resizable()
        .frame(width: 24, height: 24)
        .foregroundColor(configuration.isOn ? .accentColor : .gray)
        .onTapGesture {
          configuration.isOn.toggle()
        }
      configuration.label
    }
  }
}

struct ReminderToggleStyle_Previews: PreviewProvider {
  static var previews: some View {
    Toggle(isOn: .constant(true)) { Text("Hello") }
      .toggleStyle(ReminderToggleStyle())
  }
}
