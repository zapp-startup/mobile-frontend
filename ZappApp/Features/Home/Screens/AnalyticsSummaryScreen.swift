import SwiftUI

struct AnalyticsSummaryScreen: View {
    let metrics: [AnalyticsMetric]
    var onOpenFullAnalytics: () -> Void

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Analytics Summary", subtitle: "Quick KPI drill-down from Home")

                if metrics.isEmpty {
                    AppEmptyState(title: "No analytics data", message: "Metrics will appear after activity is tracked.")
                } else {
                    ForEach(metrics) { metric in
                        KpiCard(title: metric.title, value: metric.value, delta: metric.delta)
                    }
                    AppCard {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Tracked stacks, highest overlap, and watchlist are mirrored from your analytics engine.")
                                .font(AppTypography.helper)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }

                AppButton(title: "Open Full Analytics", action: onOpenFullAnalytics)
                Spacer()
            }
        }
    }
}
