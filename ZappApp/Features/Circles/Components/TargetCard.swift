import SwiftUI

struct TargetCard: View {
    let target: Target

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text(target.title).font(AppTypography.sectionTitle)
                    Spacer()
                    StatusChip(text: target.status.rawValue.capitalized, tone: AppColors.success)
                }
                Text(target.type).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                ProgressView(value: progress).tint(AppColors.accent)
                Text("\(value(target.currentValue)) of \(value(target.targetValue))")
                    .font(AppTypography.helper)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    private var progress: Double {
        guard target.targetValue > 0 else { return 0 }
        return min(target.currentValue / target.targetValue, 1)
    }

    private func value(_ number: Double) -> String {
        if target.unit == "USD" {
            return Formatters.currency.string(from: NSNumber(value: number)) ?? "$0.00"
        }
        return "\(Int(number)) \(target.unit)"
    }
}
