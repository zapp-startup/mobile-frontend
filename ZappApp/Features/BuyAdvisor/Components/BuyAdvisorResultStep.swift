import SwiftUI

struct BuyAdvisorResultStep: View {
    let result: BuyAdvisorResponse
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            AppHeader(title: "Recommendation")
            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(result.recommendation).font(AppTypography.display)
                    Text("Value Score: \(result.valueScore)/100")
                    Text("Confidence: \(Int(result.confidence * 100))%")
                    Text(result.rationale)
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            AppButton(title: "Analyze Again", action: onBack)
        }
    }
}
