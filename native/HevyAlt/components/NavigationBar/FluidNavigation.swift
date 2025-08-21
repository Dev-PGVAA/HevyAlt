import SwiftUI

struct FluidNavigation: View {
@State private var isSelectedTab = FluidNavigationBarDestinations.dashboard
@State private var scrollPosition: ScrollPosition?
@Namespace private var animation
var body: some View {
		VStack(spacing: 0) {
				ScrollView(.horizontal, showsIndicators: false) {
						LazyHStack(spacing: 0) {
								ForEach(FluidNavigationBarDestinations.allCases, id: \.rawValue) { tab in
										tabContainer(for: tab)
												.id(ScrollPosition(rawValue: tab.rawValue))
												.containerRelativeFrame(.horizontal)
								}
						}
						.scrollTargetLayout()
				}
				.scrollTargetBehavior(.paging)
				.scrollDisabled(true)
				.scrollPosition(id: $scrollPosition)
				.onChange(of: scrollPosition) { _, newPosition in
						if let newPosition {
								isSelectedTab = FluidNavigationBarDestinations(rawValue: newPosition.rawValue) ?? .dashboard
						}
				}
				.onChange(of: isSelectedTab) { _, newTab in
						scrollPosition = ScrollPosition(rawValue: newTab.rawValue)
				}
				.safeAreaInset(edge: .bottom) {
						FluidNavigationBar(isSelectedTab: $isSelectedTab) {
								RoundedRectangle(cornerRadius: 12)
										.fill(Color(hex: "#45EC9C"))
										.matchedGeometryEffect(id: "segment_background", in: animation)
						}
						.frame(maxWidth: .infinity, alignment: .center)
						.padding(10)
						.background(.ultraThinMaterial.blendMode(.softLight))
				}
		}
}

@ViewBuilder
func tabContainer(for tab: FluidNavigationBarDestinations) -> some View {
		switch tab {
		case .dashboard:
				DashboardView()
		case .workouts:
				WorkoutsView()
		case .calorie:
				CalorieView()
		case .calendar:
				CalendarView()
		case .profile:
				ProfileView()		
		}
}
}