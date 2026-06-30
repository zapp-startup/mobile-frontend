import SwiftUI

struct AppLoadingState: View {
    let title: String
    let message: String

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                ProgressView().tint(AppColors.accent)
                Text(title).font(AppTypography.sectionTitle)
                Text(message).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
