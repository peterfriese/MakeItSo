import SwiftUI

struct ReminderToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Image(systemName: configuration.isOn
            ? "largecircle.fill.circle"
            : "circle")
        .resizable()
        .frame(width: 24, height: 24)
        .foregroundColor(.accentColor)
        .onTapGesture {
          configuration.isOn.toggle()
        }
    }
  }
}

//struct ReminderToggleStyle_Previews: PreviewProvider {
//  static var previews: some View {
//    ReminderToggleStyle()
//  }
//}
