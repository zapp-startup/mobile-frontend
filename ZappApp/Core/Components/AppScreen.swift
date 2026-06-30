import SwiftUI

struct AppScreen<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            RadialGradient(
                colors: [AppColors.accentCyan.opacity(0.08), .clear],
                center: .top,
                startRadius: 20,
                endRadius: 380
            )
            .ignoresSafeArea()
            content
                .padding(.horizontal, AppSpacing.lg)
                .foregroundStyle(AppColors.textPrimary)
        }
    }
}
