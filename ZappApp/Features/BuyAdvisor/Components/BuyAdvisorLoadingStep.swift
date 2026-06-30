import SwiftUI

struct BuyAdvisorLoadingStep: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            ProgressView().tint(AppColors.accent)
            Text("Analyzing purchase value...").font(AppTypography.sectionTitle)
            Text("Computing recommendation and confidence scores.")
                .font(AppTypography.helper)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}
