import SwiftUI

struct AnalyticsMetricCard: View {
    let metric: AnalyticsMetric

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(metric.title).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
                Text(metric.value).font(AppTypography.sectionTitle)
                Text(metric.delta).font(AppTypography.caption).foregroundStyle(AppColors.success)
            }
        }
    }
}
