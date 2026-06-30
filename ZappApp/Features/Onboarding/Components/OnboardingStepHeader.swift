import SwiftUI

struct OnboardingStepHeader: View {
    let title: String
    let helper: String
    let progress: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(progress).font(AppTypography.caption).foregroundStyle(AppColors.accent)
            Text(title).font(AppTypography.sectionTitle)
            Text(helper).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
        }
    }
}
