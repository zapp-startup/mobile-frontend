import SwiftUI

struct SectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.sectionTitle)
                .kerning(-0.4)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(AppTypography.label)
                    .kerning(1.2)
                    .foregroundStyle(AppColors.accentCyan)
            }
        }
    }
}
