import SwiftUI

struct BadgesScreen: View {
    @StateObject private var viewModel = BadgesViewModel()

    private var latestBadge: Badge? {
        // Sort by unlockedAt descending (ISO-8601 strings sort chronologically);
        // badges without a timestamp sort last.
        viewModel.badges.max { a, b in
            (a.unlockedAt ?? "") < (b.unlockedAt ?? "")
        }
    }

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Badges")
                if viewModel.isLoading {
                    AppLoadingState(title: "Loading badges", message: "Syncing badge unlocks.")
                } else if let errorMessage = viewModel.errorMessage {
                    AppErrorState(title: "Badges Error", message: errorMessage, retry: { Task { await viewModel.load() } })
                } else if viewModel.badges.isEmpty {
                    AppEmptyState(title: "No badges yet", message: "Complete challenges to earn badges.")
                } else {
                    AppCard {
                        HStack {
                            Text("Total: \(viewModel.badges.count)").font(AppTypography.cardTitle)
                            Spacer()
                            Text("Latest: \(latestBadge?.title ?? "-")")
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
