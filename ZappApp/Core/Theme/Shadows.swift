import SwiftUI

enum AppShadows {
    static let ambient = Shadow(color: Color.black.opacity(0.45), radius: 60, x: 0, y: 20)
    static let raised = Shadow(color: Color.black.opacity(0.28), radius: 45, x: 0, y: 18)
    static let interactive = Shadow(color: AppColors.interactiveGlow, radius: 24, x: 0, y: 0)
    static let card = raised
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
