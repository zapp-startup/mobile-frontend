import SwiftUI

struct CategoryBreakdownCard: View {
    let categories: [CategorySpend]
    var onTapSeeAll: () -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader(title: "Category Breakdown", actionTitle: "See all", action: onTapSeeAll)
                if categories.isEmpty {
                    Text("No category data available yet.")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                } else {
                    ForEach(categories.prefix(4)) { category in
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            HStack {
                                Text(category.category)
                                Spacer()
                                Text(currency(category.amount)).foregroundStyle(AppColors.textSecondary)
                            }
                            ProgressView(value: category.percent)
                                .tint(AppColors.accent)
                        }
                    }
                }
            }
        }
    }

    private func currency(_ value: Double) -> String {
        Formatters.currency.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
