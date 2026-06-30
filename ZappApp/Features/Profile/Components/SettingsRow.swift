import SwiftUI

struct SettingsRow: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(AppSpacing.md)
            .background(AppColors.subtle)
            .cornerRadius(AppRadii.md)
        }
        .buttonStyle(.plain)
    }
}
