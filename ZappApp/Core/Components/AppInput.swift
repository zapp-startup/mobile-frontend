import SwiftUI

struct AppInput: View {
    let title: String
    @Binding var value: String
    var secure = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(AppTypography.label)
                .kerning(1.4)
                .foregroundStyle(AppColors.textMuted)
                .textCase(.uppercase)
            Group {
                if secure { SecureField(title, text: $value) }
                else { TextField(title, text: $value) }
            }
            .font(AppTypography.body)
            .padding(.horizontal, AppSpacing.controlX)
            .padding(.vertical, AppSpacing.controlY)
            .frame(minHeight: 48)
            .background(AppColors.inset)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadii.md)
                    .stroke(AppColors.borderStrong, lineWidth: 1)
            )
            .cornerRadius(AppRadii.md)
        }
    }
}
