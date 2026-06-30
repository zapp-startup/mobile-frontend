import SwiftUI

enum AppTypography {
    private static func inter(_ size: CGFloat, _ weight: Font.Weight) -> Font {
        Font.custom("Inter", size: size).weight(weight)
    }

    static let pageTitle = inter(48, .black)
    static let display = inter(40, .black)
    static let screenTitle = inter(32, .black)
    static let sectionTitle = inter(24, .black)
    static let cardTitle = inter(18, .heavy)
    static let body = inter(16, .regular)
    static let helper = inter(14, .regular)
    static let error = inter(14, .bold)
    static let caption = inter(12, .medium)
    static let metric = inter(36, .black)

    static let eyebrow = inter(10, .black)
    static let label = inter(11, .heavy)
    static let miniLabel = inter(10, .black)
}
