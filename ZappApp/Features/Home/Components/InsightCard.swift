import SwiftUI

struct InsightCard: View {
    let title: String
    let message: String

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(title).font(AppTypography.sectionTitle)
                Text(message).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}
