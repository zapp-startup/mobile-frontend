import SwiftUI

struct BankConnectionCard: View {
    let connection: BankConnection
    var onSync: () -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text(connection.institutionName).font(AppTypography.cardTitle)
                    Spacer()
                    StatusChip(text: connection.status.rawValue, tone: tone)
                }
                Text("Last synced: \(connection.lastSyncedAt ?? "Never")")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                if connection.canSync {
                    HStack {
                        Spacer()
                        Button("Sync Now", action: onSync).foregroundStyle(AppColors.accent)
                    }
                }
            }
        }
    }

    private var tone: Color {
        switch connection.status {
        case .active: return AppColors.success
        case .syncing: return AppColors.warning
        case .consentRequired, .mfaRequired, .error: return AppColors.warning
        }
    }
}
