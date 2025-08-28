import SwiftUI

@main
struct HevyAlt: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var authService = AuthService.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(hex: "#101010").ignoresSafeArea()
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(authService)
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        ZStack {
          if auth.isAuthorized {
                VStack(spacing: 16) {
                    Text("Вы авторизованы ✅")
                    
                    if let token = auth.accessToken {
                        Text("Access Token: \(token)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    FluidNavigation()
                    
                    Button("Выйти") {
                      auth.clearTokens()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                AuthView()
            }
        }
    }
}

// Заглушки для экранов
struct DashboardView: View {
    var body: some View { Text("Home").foregroundColor(Color(hex: "#FEFEFE")) }
}

struct WorkoutsView: View {
    var body: some View { Text("Workouts").foregroundColor(Color(hex: "#FEFEFE")) }
}

struct CalorieView: View {
    var body: some View { Text("Calorie").foregroundColor(Color(hex: "#FEFEFE")) }
}

struct CalendarView: View {
    var body: some View { Text("Calendar").foregroundColor(Color(hex: "#FEFEFE")) }
}

struct ProfileView: View {
    var body: some View { Text("Profile").foregroundColor(Color(hex: "#FEFEFE")) }
}
