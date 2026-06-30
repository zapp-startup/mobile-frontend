import SwiftUI

struct InviteCodeCard: View {
    let inviteCode: String

    var body: some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Invite Code").font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                    Text(inviteCode).font(AppTypography.sectionTitle)
                }
                Spacer()
                Image(systemName: "qrcode")
            }
        }
    }
}
