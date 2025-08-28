import SwiftUI

struct UniversalTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    var isShowPasswordErrors: Bool = false
    var errorMessage: String?

    var body: some View {
        if isSecure {
            TextFieldComponent(
                text: $text,
                placeholder: placeholder,
                isSecure: true,
                errorMessage: errorMessage,
                isShowPasswordErrors: isShowPasswordErrors
            )
        } else {
            TextFieldComponent(
                text: $text,
                placeholder: placeholder,
                isSecure: false,
                errorMessage: errorMessage
            )
        }
    }
}

struct TextFieldComponent: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    @State private var isTextVisible: Bool = false
    var errorMessage: String?
    var isShowPasswordErrors: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ZStack(alignment: .leading) {
                    if isSecure && !isTextVisible {
                        SecureField("", text: $text)
                            .textContentType(.newPassword)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(Color.white)
                            .background(Color(hex: "#181818"))
                    } else {
                        TextField("", text: $text)
                            .textContentType(.newPassword)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(Color.white)
                            .background(Color(hex: "#181818"))
                    }
                    if text.isEmpty {
                        Text(placeholder)
                            .bold()
                            .foregroundColor(Color.white.opacity(0.4))
                    }
                }
                if isSecure {
                    Button(action: {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
                            isTextVisible.toggle()
                        }
                    }) {
                        Image(systemName: isTextVisible ? "eye.fill" : "eye.slash.fill")
                            .frame(width: 18, height: 18)
                            .foregroundColor(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 14)
            .background(Color(hex: "#181818"))
            .cornerRadius(10)
            .frame(height: 56)

            if let error = errorMessage, !error.isEmpty, isShowPasswordErrors {
                Text(error)
                    .foregroundColor(Color(hex: "#dc2626"))
                    .transition(.asymmetric(insertion: .move(edge: .leading),
                                            removal: .move(edge: .trailing)))
                    .animation(.spring(response: 0.4, dampingFraction: 0.75), value: text)
            }
        }
    }
}
