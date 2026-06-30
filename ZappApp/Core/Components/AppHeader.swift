import SwiftUI

struct AppHeader: View {
    let title: String
    var subtitle: String?
    var trailing: AnyView?

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.screenTitle)
                    .kerning(-0.8)
                if let subtitle {
                    Text(subtitle)
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            Spacer()
            trailing
        }
        .padding(.vertical, AppSpacing.lg)
    }
}
