import SwiftUI

struct FluidNavigationBar<Segment: View>: View {
    @Binding var isSelectedTab: FluidNavigationBarDestinations
    @Namespace private var animation
    @ViewBuilder var segment: () -> Segment
    var body: some View {
        HStack(spacing: 24) {
            ForEach(FluidNavigationBarDestinations.allCases, id: \.rawValue) { tab in
                Button(action: {
                    withAnimation(.snappy(duration: 0.4)) {
                        isSelectedTab = tab
                    }
                }, label: {
                    HStack(spacing: 8) {
                        Image(systemName: tab.icon)
                            .foregroundStyle(isSelectedTab == tab ? Color(hex: "#101010") : Color(hex: "#FEFEFE"))
                        if isSelectedTab == tab {
                            Text(tab.title)
                                .foregroundStyle(isSelectedTab == tab ? Color(hex: "#101010") : Color(hex: "#FEFEFE"))
                                .transition(.opacity)
                        }
                    }
                    .font(.system(size: 15, weight: .medium))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .foregroundStyle(isSelectedTab == tab ? .black : .secondary)
                    .background {
                        if isSelectedTab == tab {
                            segment()
                                .matchedGeometryEffect(id: "segment_background", in: animation)
                        }
                    }
                })
                .buttonStyle(.plain)
            }
        }
    }
}
