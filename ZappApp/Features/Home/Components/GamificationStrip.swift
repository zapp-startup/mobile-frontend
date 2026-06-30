import SwiftUI

struct GamificationStrip: View {
    let circle: Circle?

    var body: some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(circle?.name ?? "Circles")
                        .font(AppTypography.cardTitle)
                    Text(circle == nil ? "Join a circle to start streak challenges." : "Rank #\(circle?.leaderboard.first?.rank ?? 0) this week")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                }
                Spacer()
                StatusChip(text: circle == nil ? "No Active Circle" : "Active", tone: circle == nil ? AppColors.warning : AppColors.success)
            }
        }
    }
}
