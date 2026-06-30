import SwiftUI

struct SpendingCalendarCard: View {
    let totalSpent: Double

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Spending Calendar").font(AppTypography.sectionTitle)
                Text("Monthly spend trend preview").font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
                Text(Formatters.currency.string(from: NSNumber(value: totalSpent)) ?? "$0.00")
                    .font(AppTypography.metric)
            }
        }
    }
}
