import SwiftUI

struct MainAuthView: View {
	@Binding var typeOfAuth: AuthView.AuthType

	var body: some View {
				VStack {			
					VStack {
						Button(action: {
							// Google sign-in action
						}) {
							HStack {
								Image("google_icon")
								Text("Continue with Google")
									.foregroundColor(.black)
									.font(.headline)
							}
							.padding()
							.frame(maxWidth: .infinity)
							.background(Color.white)
							.cornerRadius(12)
						}
					}
					.padding(.top, 12)
					HStack {
						Rectangle()
							.fill(Color.white.opacity(0.5))
							.frame(height: 1)
						Text("or")
							.font(.subheadline)
							.foregroundColor(.white)
							.padding(.horizontal, 8)
						Rectangle()
							.fill(Color.white.opacity(0.5))
							.frame(height: 1)
					}
					HStack(spacing: 16) {
						Button(action: {
							typeOfAuth = .register
						}) {
							Text("Register")
								.font(.headline)
								.padding()
								.frame(maxWidth: .infinity)
								.background(Color(hex: "#FF8F5C"))
								.foregroundColor(Color(hex: "#101010"))
								.cornerRadius(12)
						}
						Button(action: {
							typeOfAuth = .login
						}) {
							Text("Login")
								.font(.headline)
								.padding()
								.frame(maxWidth: .infinity)
								.background(Color.clear)
								.foregroundColor(.white)
								.overlay(
									RoundedRectangle(cornerRadius: 12)
										.stroke(Color.white, lineWidth: 1)
								)
								.cornerRadius(12)
						}
					}
				}
	}
}
