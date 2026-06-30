import SwiftUI

struct AppEmptyState: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "tray")
            Text(title).font(AppTypography.sectionTitle)
            Text(message).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
