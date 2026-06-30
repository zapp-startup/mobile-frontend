import SwiftUI

struct AppErrorState: View {
    let title: String
    let message: String
    var retry: (() -> Void)?

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(AppColors.error)
            Text(title).font(AppTypography.sectionTitle)
            Text(message).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
            if let retry {
                AppButton(title: "Try Again", action: retry)
            }
        }
    }
}
