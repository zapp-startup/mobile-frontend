import SwiftUI

struct SubscriptionValuationSection: View {
    let valuation: SubscriptionValuation?

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Valuation").font(AppTypography.sectionTitle)
                if let valuation {
                    SubscriptionValueCard(valueScore: valuation.valueScore, confidence: valuation.confidence)
                    Text(valuation.explanation)
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                } else {
                    Text("No valuation data yet.")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }
}
