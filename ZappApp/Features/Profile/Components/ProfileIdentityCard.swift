import SwiftUI

struct ProfileIdentityCard: View {
    let user: User

    var body: some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(user.fullName).font(AppTypography.sectionTitle)
                    Text(user.email).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
                    Text("Tier: \(user.tier)").font(AppTypography.caption).foregroundStyle(AppColors.accent)
                }
                Spacer()
                Text(user.initials)
                    .font(AppTypography.sectionTitle)
                    .padding(AppSpacing.md)
                    .background(AppColors.subtle)
                    .clipShape(SwiftUI.Circle())
            }
        }
    }
}
