import SwiftUI

struct InsightsListSection: View {
    let insights: [String]

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Insights").font(AppTypography.sectionTitle)
                if insights.isEmpty {
                    Text("No insights yet. Compute a valuation to generate insights.")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                } else {
                    ForEach(insights, id: \.self) { insight in
                        HStack(alignment: .top, spacing: AppSpacing.sm) {
                            Text("•")
                            Text(insight).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }
            }
        }
    }
}
