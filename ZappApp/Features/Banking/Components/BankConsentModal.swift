import SwiftUI

struct BankConsentModal: View {
    @Environment(\.dismiss) private var dismiss
    var onContinue: () -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(title: "Bank Data Consent", subtitle: "Review and approve secure data access.")
                    AppCard {
                        Text("Zapp will access balances, accounts, and transactions to provide synced insights.")
                            .font(AppTypography.helper)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    AppButton(title: "Continue") {
                        onContinue()
                        dismiss()
                    }
                    Button("Cancel") { dismiss() }.foregroundStyle(AppColors.warning)
                    Spacer()
                }
            }
        }
    }
}
