import SwiftUI

struct BadgesScreen: View {
    @StateObject private var viewModel = BadgesViewModel()

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Badges")
                if viewModel.isLoading {
                    AppLoadingState(title: "Loading badges", message: "Syncing badge unlocks.")
                } else if let errorMessage = viewModel.errorMessage {
                    AppErrorState(title: "Badges Error", message: errorMessage, retry: nil)
                } else if viewModel.badges.isEmpty {
                    AppEmptyState(title: "No badges yet", message: "Complete challenges to earn badges.")
                } else {
                    AppCard {
                        HStack {
                            Text("Total: \(viewModel.badges.count)").font(AppTypography.cardTitle)
                            Spacer()
                            Text("Latest: \(viewModel.badges.first?.title ?? "-")")
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                    ScrollView { BadgeGrid(badges: viewModel.badges) }
                }
                Spacer()
            }
            .task { await viewModel.load() }
        }
    }
}
