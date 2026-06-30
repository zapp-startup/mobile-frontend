import SwiftUI

struct AppTextarea: View {
    let title: String
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(AppTypography.label)
                .kerning(1.4)
                .foregroundStyle(AppColors.textMuted)
                .textCase(.uppercase)
            TextEditor(text: $value)
                .frame(minHeight: 110)
                .padding(AppSpacing.md)
                .background(AppColors.inset)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.md)
                        .stroke(AppColors.borderStrong, lineWidth: 1)
                )
                .cornerRadius(AppRadii.md)
        }
    }
}
