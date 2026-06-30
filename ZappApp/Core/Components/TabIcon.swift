import SwiftUI

struct TabIcon: View {
    let tab: AppTab
    let isSelected: Bool

    var body: some View {
        Label(tabTitle, systemImage: tabSymbol)
            .foregroundStyle(isSelected ? AppColors.accent : AppColors.textSecondary)
    }

    private var tabTitle: String {
        switch tab {
        case .home: return "Home"
        case .transactions: return "Transactions"
        case .subscriptions: return "Subscriptions"
        case .circles: return "Circles"
        case .profile: return "Profile"
        }
    }

    private var tabSymbol: String {
        switch tab {
        case .home: return "house.fill"
        case .transactions: return "list.bullet.rectangle"
        case .subscriptions: return "repeat.circle"
        case .circles: return "person.3.fill"
        case .profile: return "person.crop.circle"
        }
    }
}
