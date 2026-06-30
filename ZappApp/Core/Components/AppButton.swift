import SwiftUI

struct AppButton: View {
    let title: String
    var isLoading = false
    var tone: Color = AppColors.accentCyan
    var foreground: Color = AppColors.textInverse
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading { ProgressView() }
                else {
                    Text(title)
                        .font(AppTypography.cardTitle)
                        .textCase(.uppercase)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppSpacing.controlX)
            .padding(.vertical, AppSpacing.controlY)
            .foregroundStyle(foreground)
            .background(tone)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadii.pill)
                    .stroke(AppColors.borderStrong, lineWidth: 1)
            )
            .cornerRadius(AppRadii.pill)
            .shadow(color: tone.opacity(0.28), radius: 12, x: 0, y: 0)
            .scaleEffect(isLoading ? 0.99 : 1)
            .animation(.easeOut(duration: 0.18), value: isLoading)
        }
        .buttonStyle(.plain)
    }
}
