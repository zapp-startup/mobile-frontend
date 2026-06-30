import SwiftUI

struct SpotifyIntegrationCard: View {
    let connection: SpotifyConnection?
    let isLoading: Bool
    var onConnect: () -> Void
    var onSync: () -> Void
    var onDisconnect: () -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    Text("Spotify Integration").font(AppTypography.sectionTitle)
                    Spacer()
                    StatusChip(text: connection?.status.rawValue.capitalized ?? "Disconnected", tone: tone)
                }
                Text(connection?.statusMessage ?? "Connect Spotify to enrich subscription insights.")
                    .font(AppTypography.helper)
                    .foregroundStyle(AppColors.textSecondary)

                if let connection, connection.status == .connected {
                    HStack(spacing: AppSpacing.md) {
                        AppButton(title: "Sync", isLoading: isLoading, action: onSync)
                        AppButton(title: "Disconnect", isLoading: isLoading, action: onDisconnect)
                    }
                } else {
                    AppButton(title: "Connect Spotify", isLoading: isLoading, action: onConnect)
                }
            }
        }
    }

    private var tone: Color {
        switch connection?.status {
        case .connected: return AppColors.success
        case .syncing: return AppColors.warning
        case .error: return AppColors.error
        default: return AppColors.warning
        }
    }
}
