import SwiftUI
import UIKit

struct InviteCodeCard: View {
    let inviteCode: String

    var body: some View {
        AppCard {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Invite Code").font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                    Button {
                        UIPasteboard.general.string = inviteCode
                    } label: {
                        HStack(spacing: AppSpacing.xs) {
                            Text(inviteCode).font(AppTypography.sectionTitle)
                            Image(systemName: "doc.on.doc")
                        }
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                Image(systemName: "qrcode")
            }
        }
    }
}
