import SwiftUI

@main
struct HevyAlt: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(hex: "#101010").ignoresSafeArea()
                AuthView()
                // FluidNavigation()
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
