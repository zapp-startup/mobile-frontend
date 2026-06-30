import SwiftUI

struct BankingEmptyState: View {
    var onConnect: () -> Void

    var body: some View {
        AppCard {
            VStack(spacing: AppSpacing.md) {
                Text("No bank connections yet").font(AppTypography.sectionTitle)
                Text("Connect your bank to unlock synced transactions and insights.")
                    .font(AppTypography.helper)
                    .foregroundStyle(AppColors.textSecondary)
                AppButton(title: "Connect Bank", action: onConnect)
            }
        }
    }
}
