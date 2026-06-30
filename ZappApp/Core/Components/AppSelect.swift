import SwiftUI

struct AppSelect: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.label)
                .kerning(1.2)
                .foregroundStyle(AppColors.textMuted)
                .textCase(.uppercase)
            Spacer()
            Text(value).font(AppTypography.body)
        }
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
