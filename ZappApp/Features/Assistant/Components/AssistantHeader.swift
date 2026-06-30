import SwiftUI

struct AssistantHeader: View {
    var onNewChat: () -> Void
    var onClose: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("Zapp Assistant").font(AppTypography.sectionTitle)
                Text("Ask ZappBot anything")
                    .font(AppTypography.miniLabel)
                    .kerning(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(AppColors.textMuted)
            }
            Spacer()
            Button("New Chat", action: onNewChat).foregroundStyle(AppColors.accentPurple)
            Button("Close", action: onClose).foregroundStyle(AppColors.accentCyan)
        }
    }
}
