import SwiftUI
import Combine
import AuthenticationServices
import FirebaseAnalyticsSwift

private enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

struct SignupView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?

  var body: some View {
    VStack {
      HStack {
        Image(colorScheme == .light ? "logo-light" : "logo-dark")
          .resizable()
          .frame(width: 30, height: 30 , alignment: .center)
          .cornerRadius(8)
        Text("Make It So")
          .font(.title)
          .bold()
      }
      .padding(.horizontal)

      VStack {
        Image(colorScheme == .light ? "auth-hero-light" : "auth-hero-dark")
          .resizable()
          .frame(maxWidth: .infinity)
          .scaledToFit()
          .padding(.vertical, 24)

        Text("Get your work done. Make it so.")
          .font(.title2)
          .padding(.bottom, 16)
      }

      Spacer()


      Button(action: {
        withAnimation {
          viewModel.isOtherAuthOptionsVisible.toggle()
        }
      }) {
        Text("More sign-in options")
          .underline()
      }
      .buttonStyle(.plain)
      .padding(.top, 16)

      if viewModel.isOtherAuthOptionsVisible {
        emailPasswordSignInArea
      }

      HStack {
        Text("Already have an account?")
        Button(action: { viewModel.switchFlow() }) {
          Text("Log in")
            .fontWeight(.semibold)
            .foregroundColor(.blue)
        }
      }
      .padding(.vertical, 8)
    }
    .padding()
    .analyticsScreen(name: "\(Self.self)")
  }
}


struct SignupView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SignupView()
      SignupView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
