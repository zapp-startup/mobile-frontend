import SwiftUI

struct StatusChip: View {
    let text: String
    var tone: Color = AppColors.accent

    var body: some View {
        Text(text)
            .font(AppTypography.miniLabel)
            .kerning(1.3)
            .textCase(.uppercase)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xs)
            .background(tone.opacity(0.12))
            .overlay(
                Capsule().stroke(tone.opacity(0.35), lineWidth: 1)
            )
            .foregroundStyle(tone)
            .clipShape(Capsule())
    }
}
