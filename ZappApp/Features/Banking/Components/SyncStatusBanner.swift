import SwiftUI

struct SyncStatusBanner: View {
    let message: String

    var body: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text(message).font(AppTypography.caption)
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.warning.opacity(0.2))
        .cornerRadius(AppRadii.md)
    }
}
