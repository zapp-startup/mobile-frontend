import SwiftUI

struct TypingIndicator: View {
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            ProgressView().controlSize(.small)
            Text("Assistant is typing...")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
            Spacer()
        }
        .padding(AppSpacing.sm)
    }
}
