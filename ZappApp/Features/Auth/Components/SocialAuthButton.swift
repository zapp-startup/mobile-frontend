import SwiftUI

struct SocialAuthButton: View {
    let title: String
    var isLoading = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "globe")
                Text(isLoading ? "Connecting..." : title)
                    .font(AppTypography.cardTitle)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.subtle)
            .foregroundStyle(AppColors.textPrimary)
            .cornerRadius(AppRadii.md)
        }
        .buttonStyle(.plain)
    }
}
