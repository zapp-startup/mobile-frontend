import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showAnalyticsSummary = false

    var onOpenAnalytics: () -> Void
    var onOpenAssistant: () -> Void
    var onOpenSearch: () -> Void
    var onOpenBuyAdvisor: () -> Void

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    AppHeader(
                        title: "Home",
                        trailing: AnyView(headerActions)
                    )

                    if viewModel.isLoading && !viewModel.hasData {
                        AppCard {
                            VStack(spacing: AppSpacing.md) {
                                ProgressView().tint(AppColors.accent)
                                Text("Loading dashboard").font(AppTypography.sectionTitle)
                                Text("Fetching your latest finance snapshot.")
                                    .font(AppTypography.helper)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.xl)
                        }
                    } else if let errorMessage = viewModel.errorMessage, !viewModel.hasData {
                        AppErrorState(title: "Could not load dashboard", message: errorMessage) {
                            Task { await viewModel.load() }
                        }
                    } else {
                        dashboardContent
                    }

                    AppButton(title: "Open Buy Advisor", action: onOpenBuyAdvisor)
                }
            }
            .refreshable { await viewModel.load() }
            .task { await viewModel.load() }
            .navigationDestination(isPresented: $showAnalyticsSummary) {
                AnalyticsSummaryScreen(metrics: viewModel.metrics, onOpenFullAnalytics: onOpenAnalytics)
            }
        }
    }

    private var headerActions: some View {
        HStack(spacing: AppSpacing.sm) {
            Button("Search", action: onOpenSearch).foregroundStyle(AppColors.accent)
            Button("Assistant", action: onOpenAssistant).foregroundStyle(AppColors.accent)
            Button("Analytics", action: onOpenAnalytics).foregroundStyle(AppColors.accent)
        }
        .font(AppTypography.caption)
    }

    private var dashboardContent: some View {
        VStack(spacing: AppSpacing.lg) {
            GamificationStrip(circle: viewModel.circles.first)
            DashboardHeroCard(
                totalSpent: viewModel.totalSpent,
                totalIncome: viewModel.totalIncome,
                valueScore: viewModel.valueScoreAverage
            )

            VStack(spacing: AppSpacing.md) {
                SectionHeader(title: "Key Metrics")
                ForEach(viewModel.kpis) { kpi in
                    KpiCard(title: kpi.title, value: kpi.value, delta: kpi.delta)
                }
            }

            CategoryBreakdownCard(categories: viewModel.categoryBreakdown) {
                showAnalyticsSummary = true
            }

            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Recent Transactions", actionTitle: "See all") { }
                    if viewModel.recentTransactions.isEmpty {
                        AppEmptyState(title: "No transactions yet", message: "Your latest transactions will appear here.")
                            .frame(height: 120)
                    } else {
                        ForEach(viewModel.recentTransactions.prefix(5)) { transaction in
                            RecentTransactionCard(transaction: transaction)
                        }
                    }
                }
            }

            InsightCard(title: "Insight", message: viewModel.topInsight)
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen(
            onOpenAnalytics: {},
            onOpenAssistant: {},
            onOpenSearch: {},
            onOpenBuyAdvisor: {}
        )
    }
}
