import SwiftUI

struct AddReminderView: View {
  enum FocusableField: Hashable {
    case title
  }

  @FocusState
  private var focusedField: FocusableField?

  @State
  private var reminder = Reminder(title: "")

  @Environment(\.dismiss)
  private var dismiss

  var completion: (_ reminder: Reminder) -> Void

  private func commit() {
    completion(reminder)
    dismiss()
  }

  var body: some View {
    NavigationStack {
      Form {
        TextField("Title", text: $reminder.title)
          .focused($focusedField, equals: .title)
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
