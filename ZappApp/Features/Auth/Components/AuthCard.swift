import SwiftUI

struct AuthCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(title).font(AppTypography.sectionTitle)
                    Text(subtitle).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
                }
                content
            }
        }
    }
}
