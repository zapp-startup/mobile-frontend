import SwiftUI

struct LeaderboardRow: View {
    let entry: CircleLeaderboardEntry

    var body: some View {
        HStack {
            Text("#\(entry.rank)").font(AppTypography.cardTitle)
            Text(entry.memberName)
            Spacer()
            Text("\(entry.score) pts").foregroundStyle(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .background(AppColors.subtle)
        .cornerRadius(AppRadii.md)
    }
}
