import SwiftUI

struct MessageBubble: View {
    let message: AssistantMessage
    var onQuickAction: (QuickAction) -> Void

    var body: some View {
        VStack(alignment: message.role == .user ? .trailing : .leading, spacing: AppSpacing.xs) {
            Text(message.content)
                .padding(AppSpacing.lg)
                .background(message.role == .user ? AppColors.accentPurpleSoft : AppColors.inset)
                .foregroundStyle(AppColors.textPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.lg)
                        .stroke(message.role == .user ? AppColors.accentPurple.opacity(0.35) : AppColors.borderStrong, lineWidth: 1)
                )
                .cornerRadius(AppRadii.lg)
                .shadow(color: message.role == .user ? AppColors.botGlow : .clear, radius: 10, x: 0, y: 0)
                .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .assistant, !message.quickActions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(message.quickActions) { action in
                            QuickActionChip(title: action.title) { onQuickAction(action) }
                        }
                    }
                }
            }
        }
    }
}
