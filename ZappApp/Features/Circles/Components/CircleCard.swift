import SwiftUI

struct CircleCard: View {
    let circle: Circle
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    HStack {
                        Text(circle.name).font(AppTypography.sectionTitle)
                        Spacer()
                        StatusChip(text: circle.privacy.rawValue.capitalized, tone: AppColors.accent)
                    }
                    Text("\(circle.memberCount) members")
                        .font(AppTypography.helper)
                        .foregroundStyle(AppColors.textSecondary)
                    Text("Invite: \(circle.inviteCode)")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
