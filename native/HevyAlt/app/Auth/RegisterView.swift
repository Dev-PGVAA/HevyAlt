import SwiftUI

struct RegisterView: View {
    @Binding var typeOfAuth: AuthView.AuthType
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @StateObject private var validator = PasswordValidator()
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @EnvironmentObject var authService: AuthService

    var body: some View {
      VStack(spacing: 12) {
        HStack(spacing: 16) {
          UniversalTextField(text: $firstName, placeholder: "First name")
          UniversalTextField(text: $lastName, placeholder: "Last name")
        }
        UniversalTextField(text: $email, placeholder: "E-mail")
        UniversalTextField(
          text: $validator.password,
          placeholder: "Password",
          isSecure: true,
					isShowPasswordErrors: true,
          errorMessage: {
            if let firstInvalid = validator.requirements.first(where: { !$0.isValid }),
               !validator.password.isEmpty {
              return firstInvalid.name
            }
            return ""
          }()
        )            
				Button(action: registerAction) {
						HStack {
								if isLoading {
										ProgressView()
												.progressViewStyle(CircularProgressViewStyle(tint: .black))
								} else {
										Text("Register")
												.foregroundColor(.black)
												.font(.headline)
								}
						}
						.padding()
						.frame(maxWidth: .infinity)
						.background(Color.white)
						.cornerRadius(12)
					}
					.disabled(isLoading || firstName.isEmpty || lastName.isEmpty || email.isEmpty || validator.password.isEmpty)
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
        
      authService.register(email: email, password: validator.password, name: "\(firstName) \(lastName)") { success in
        DispatchQueue.main.async {
          isLoading = false
          if success {
            print("✅ Регистрация успешна")
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")  // Меняем AppStorage флаг
          } else {
            print("❌ Ошибка регистрации")
            errorMessage = "Ошибка при регистрации"
          }
        }
      }
    }
}
