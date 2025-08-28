import SwiftUI

struct LoginView: View {
    @Binding var typeOfAuth: AuthView.AuthType
    
    @State private var email: String = ""
    @StateObject private var validator = PasswordValidator()
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @EnvironmentObject var authService: AuthService

    var body: some View {
      VStack(spacing: 12) {
        UniversalTextField(text: $email, placeholder: "E-mail")
        UniversalTextField(
          text: $validator.password,
          placeholder: "Password",
          isSecure: true,
        )
            Button(action: registerAction) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text("Login")
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(12)
            }
            .disabled(isLoading || email.isEmpty || validator.password.isEmpty)
            HStack {
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 1)
                Button(action: {
                    typeOfAuth = .main
                }) {
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#fefefe").opacity(0.8))
                    Text("Go Back")
                        .foregroundColor(Color(hex: "#fefefe").opacity(0.8))
                        .font(.system(size: 15))
                }
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 1)
            }
            .padding(.top, 8)
      }
      .padding(.top, 16)
    }
		private func registerAction() {
        isLoading = true
        errorMessage = nil
        
        authService.login(email: email, password: validator.password) { success in
          print(success ? "✅ Вход успешна" : "❌ Ошибка входа")
        }
    }
}
