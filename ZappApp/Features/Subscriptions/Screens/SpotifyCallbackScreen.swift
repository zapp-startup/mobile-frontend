import SwiftUI

struct SpotifyCallbackScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SpotifyViewModel()
    @State private var isComplete = false
    @State private var hasError = false

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                ProgressView().tint(AppColors.accent)
                Text("Finishing Spotify connection").font(AppTypography.sectionTitle)
                if hasError {
                    Text(viewModel.errorMessage ?? "Spotify callback failed. Please retry.")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.error)
                } else {
                    Text(isComplete ? "Spotify connected successfully." : "Finalizing callback and syncing initial data...")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
                await viewModel.resolveCallback()
                hasError = viewModel.connection?.status != .connected
                isComplete = !hasError
                try? await Task.sleep(nanoseconds: 700_000_000)
                dismiss()
            }
        }
    }
}
