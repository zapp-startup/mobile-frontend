import SwiftUI

struct DashboardHeroCard: View {
    let totalSpent: Double
    let totalIncome: Double
    let valueScore: Int

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Financial Health").font(AppTypography.sectionTitle)
                Text(currency(totalIncome - totalSpent))
                    .font(AppTypography.display)
                Text("Net cashflow this cycle")
                    .font(AppTypography.helper)
                    .foregroundStyle(AppColors.textSecondary)
                ValueScoreMeter(score: Double(valueScore))
            }
        }
    }

    private func currency(_ value: Double) -> String {
        Formatters.currency.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
