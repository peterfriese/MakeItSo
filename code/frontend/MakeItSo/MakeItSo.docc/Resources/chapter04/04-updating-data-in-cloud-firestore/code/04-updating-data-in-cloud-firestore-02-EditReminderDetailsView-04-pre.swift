import SwiftUI

struct EditReminderDetailsView: View {
  enum FocusableField: Hashable {
    case title
  }

  @FocusState
  private var focusedField: FocusableField?

  enum Mode {
    case add
    case edit
  }

  var mode: Mode = .add

  @State
  var reminder = Reminder(title: "")

  @Environment(\.dismiss)
  private var dismiss

  let onCommit: (_ reminder: Reminder) -> Void

  private func commit() {
    onCommit(reminder)
    dismiss()
  }

  private func cancel() {
    dismiss()
  }

  var body: some View {
    NavigationStack {
      Form {
        TextField("Title", text: $reminder.title)
          .focused($focusedField, equals: .title)
      }
      .navigationTitle(mode == .add ? "New Reminder" : "Details")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(action: cancel) {
            Text("Cancel")
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(action: commit) {
            Text(mode == .add ? "Add" : "Done")
          }
          .disabled(reminder.title.isEmpty)
        }
      }
      .onAppear {
        focusedField = .title
      }
    }
  }
}

struct EditReminderDetailsView_Previews: PreviewProvider {















}
