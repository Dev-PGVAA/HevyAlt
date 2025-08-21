import SwiftUI

// MARK: - Navigation Tabs Enum
enum FluidNavigationBarDestinations: Int, CaseIterable {
    case dashboard
		case workouts
		case calorie
		case calendar
		case profile
    
    var title: String {
        switch self {
        case .dashboard: return "Home"
        case .workouts: return "Workout"
        case .calorie: return "Calories"
        case .calendar: return "Calendar"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "house.fill"
        case .workouts: return "dumbbell.fill"
				case .calorie: return "carrot.fill"
        case .calendar: return "calendar"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

// MARK: - Scroll Position Enum
enum ScrollPosition: Int, Hashable {
    case dashboard, workouts, calorie, calendar, profile
}
