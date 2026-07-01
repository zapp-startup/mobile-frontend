import SwiftUI

struct ComposerBar: View {
    @Binding var text: String
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            TextField("Ask ZappBot anything...", text: $text)
                .padding(.horizontal, AppSpacing.controlX)
                .padding(.vertical, AppSpacing.controlY)
                .background(AppColors.inset)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.pill)
                        .stroke(AppColors.borderStrong, lineWidth: 1)
                )
                .cornerRadius(AppRadii.md)
                .onSubmit(onSend)
            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(AppColors.textInverse)
                    .padding(AppSpacing.md)
                    .background(AppColors.accentCyan)
                    .overlay(
                        SwiftUI.Circle().stroke(AppColors.borderStrong, lineWidth: 1)
                    )
                    .shadow(color: AppColors.accentCyan.opacity(0.4), radius: 12, x: 0, y: 0)
                    .clipShape(SwiftUI.Circle())
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}
