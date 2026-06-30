import SwiftUI

struct ValueScoreBreakdownCard: View {
    let valueScore: Int
    let satisfaction: Int?

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Value Score Breakdown").font(AppTypography.sectionTitle)
                ValueScoreMeter(score: Double(valueScore))
                if let satisfaction {
                    Text("Satisfaction: \(satisfaction)/10")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }
}
