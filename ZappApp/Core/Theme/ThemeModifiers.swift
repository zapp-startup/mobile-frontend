import SwiftUI

struct ZappCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.card)
            .background(AppColors.elevated)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadii.lg)
                    .stroke(AppColors.borderSubtle, lineWidth: 1)
            )
            .cornerRadius(AppRadii.lg)
            .shadow(
                color: AppShadows.card.color,
                radius: AppShadows.card.radius,
                x: AppShadows.card.x,
                y: AppShadows.card.y
            )
            .shadow(
                color: AppColors.cardGlow,
                radius: 12,
                x: 0,
                y: 0
            )
    }
}

extension View {
    func zappCardStyle() -> some View {
        modifier(ZappCardStyle())
    }
}
