import SwiftUI

enum AppTypography {
    // Native SF Pro. Rounded design + monospaced digits carry the "engineered numerals"
    // signature on money/metrics; a real weight ladder (bold → semibold → regular → medium)
    // gives hierarchy the old all-`.black` scale lacked. (Replaces the never-bundled "Inter".)
    private static func rounded(_ size: CGFloat, _ weight: Font.Weight) -> Font {
        Font.system(size: size, weight: weight, design: .rounded)
    }

    private static func sans(_ size: CGFloat, _ weight: Font.Weight) -> Font {
        Font.system(size: size, weight: weight, design: .default)
    }

    static let pageTitle = rounded(34, .bold)
    static let display = rounded(28, .bold)
    static let screenTitle = rounded(26, .bold)
    static let sectionTitle = rounded(20, .semibold)
    static let cardTitle = sans(17, .semibold)
    static let body = sans(16, .regular)
    static let helper = sans(14, .regular)
    static let error = sans(14, .semibold)
    static let caption = sans(12, .medium)
    static let metric = rounded(32, .bold).monospacedDigit()

    static let eyebrow = sans(11, .semibold)
    static let label = sans(12, .semibold)
    static let miniLabel = sans(10, .semibold)
}
