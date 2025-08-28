import SwiftUI

struct AuthView: View {
    enum AuthType {
        case main
        case register
        case login
        case forgotPassword
    }

    @State var typeOfAuth: AuthType = .main

	@State private var keyboardIsShown = false
    private let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    private let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    var body: some View {
        ZStack {
            VStack(spacing: 0) {

              Image("auth-banner")
                  .resizable()
                  .scaledToFill()
                  .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
                  .clipped() // Обрезаем лишнее по размеру рамки
                  .overlay(
                      keyboardIsShown ?
                      Color.black.opacity(0.4)
                          .transition(.opacity)
                      : nil
                  )
                  .ignoresSafeArea(edges: .top)
                Spacer()
            }

            VStack(alignment: .leading) {
								VStack(alignment: .leading) {
									Image("Logo")
											.resizable()
											.scaledToFit()
											.frame(width: 90, height: 90)
											.cornerRadius(28)
									Text("Welcome to HevyAlt")
                    .font(.title)
											.fontWeight(.bold)
											.foregroundColor(Color(hex: "#FEFEFE"))
									Text("Track your workouts, nutrition, and progress all in one place.")
											.font(.subheadline)
											.foregroundColor(.white)
								}
								.animation(.spring(duration: 0.12), value: typeOfAuth)
								Group {
										if typeOfAuth == .register {
												RegisterView(typeOfAuth: $typeOfAuth)
														.id(typeOfAuth)
														.transition(.asymmetric(
																insertion: .move(edge: .trailing).combined(with: .opacity),
																removal: .move(edge: .leading).combined(with: .opacity))
														)
										} else if typeOfAuth == .login {
												LoginView(typeOfAuth: $typeOfAuth)
														.id(typeOfAuth)
														.transition(.asymmetric(
																insertion: .move(edge: .trailing).combined(with: .opacity),
																removal: .move(edge: .leading).combined(with: .opacity))
														)
										} else {
												MainAuthView(typeOfAuth: $typeOfAuth)
														.id(typeOfAuth)
														.transition(.asymmetric(
																insertion: .move(edge: .leading).combined(with: .opacity),
																removal: .move(edge: .trailing).combined(with: .opacity))
														)
										}
								}
								.animation(.spring(duration: 0.17), value: typeOfAuth)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .onReceive(keyboardWillShow) { _ in
            withAnimation {
                keyboardIsShown = true
            }
        }
        .onReceive(keyboardWillHide) { _ in
            withAnimation {
                keyboardIsShown = false
            }
        }
    }
}
