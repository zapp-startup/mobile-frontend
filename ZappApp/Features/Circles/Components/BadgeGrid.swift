import SwiftUI

struct BadgeGrid: View {
    let badges: [Badge]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.md) {
            ForEach(badges) { badge in
                AppCard {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Image(systemName: badge.iconName).foregroundStyle(AppColors.accent)
                        Text(badge.title).font(AppTypography.cardTitle)
                        Text(badge.description).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
    }
}
