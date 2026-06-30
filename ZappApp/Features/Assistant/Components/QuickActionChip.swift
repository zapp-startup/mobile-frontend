import SwiftUI

struct QuickActionChip: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.miniLabel)
                .kerning(1)
                .textCase(.uppercase)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.accentCyanSoft)
                .overlay(
                    Capsule().stroke(AppColors.accentCyan.opacity(0.35), lineWidth: 1)
                )
                .foregroundStyle(AppColors.accentCyan)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
