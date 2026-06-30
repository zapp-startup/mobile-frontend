import SwiftUI

struct KpiCard: View {
    let title: String
    let value: String
    let delta: String

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.eyebrow)
                    .kerning(2)
                    .textCase(.uppercase)
                    .foregroundStyle(AppColors.textMuted)
                Text(value)
                    .font(AppTypography.metric)
                Text(delta)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.accentGreen)
            }
        }
    }
}
