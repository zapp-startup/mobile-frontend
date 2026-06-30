import SwiftUI

struct ValueScoreMeter: View {
    let score: Double

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Value Score")
                .font(AppTypography.eyebrow)
                .kerning(2)
                .textCase(.uppercase)
                .foregroundStyle(AppColors.textMuted)

            GeometryReader { proxy in
                let width = proxy.size.width
                let normalized = min(max(score, 0), 150) / 150
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: AppRadii.pill)
                        .fill(AppColors.trackWhite05)
                    RoundedRectangle(cornerRadius: AppRadii.pill)
                        .fill(scoreColor)
                        .frame(width: width * normalized)
                        .shadow(color: scoreColor.opacity(0.45), radius: 8, x: 0, y: 0)
                }
            }
            .frame(height: 10)

            Text("\(Int(score))/150")
                .font(AppTypography.cardTitle)
                .foregroundStyle(scoreColor)
        }
    }

    private var scoreColor: Color {
        switch score {
        case ..<60: return AppColors.accentRed
        case ..<80: return AppColors.accentOrange
        case ..<100: return AppColors.accentYellow
        case ..<101: return AppColors.accentCyan
        default: return AppColors.accentGreen
        }
    }
}
