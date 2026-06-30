import SwiftUI

struct MemberRow: View {
    let member: CircleMember

    var body: some View {
        HStack {
            Text(member.displayName).font(AppTypography.cardTitle)
            if member.isCurrentUser {
                StatusChip(text: "You", tone: AppColors.accent)
            }
            Spacer()
            Text("Rank \(member.rank)").foregroundStyle(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .background(AppColors.subtle)
        .cornerRadius(AppRadii.md)
    }
}
