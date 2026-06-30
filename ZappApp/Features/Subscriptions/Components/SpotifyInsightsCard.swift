import SwiftUI

struct SpotifyInsightsCard: View {
    let connection: SpotifyConnection?

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Spotify Insights").font(AppTypography.sectionTitle)
                if let connection, connection.status == .connected {
                    Text("Account: \(connection.accountName ?? "-") • Plan: \(connection.product ?? "-")")
                        .font(AppTypography.helper)
                    Text("Listening consistency can influence entertainment value scoring.")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                } else if let connection, connection.status == .syncing {
                    Text("Spotify insights are syncing...")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.warning)
                } else {
                    Text("Connect Spotify to view behavior-driven insights.")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }
}
