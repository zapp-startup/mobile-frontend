import SwiftUI

enum AppColors {
    // Core app dark defaults (source-of-truth parity)
    static let background = Color(hex: "#0B1220")
    static let elevated = Color(hex: "#101A2E")
    static let subtle = Color(hex: "#14203A")
    static let inset = Color(hex: "#08111F")

    static let textPrimary = Color(hex: "#FFFFFF")
    static let textSecondary = Color(hex: "#CBD5E1")
    static let textMuted = Color(hex: "#6B7280")
    static let textFaint = Color(hex: "#4B5563")
    static let textInverse = Color(hex: "#08111F")

    static let borderSubtle = Color.white.opacity(0.06)
    static let borderStrong = Color.white.opacity(0.12)
    static let borderFocus = Color(red: 0.61, green: 0.92, blue: 0.96)
    static let borderMuted = borderSubtle

    static let accentCyan = Color(hex: "#22F0FF")
    static let accentTeal = Color(hex: "#00FFD1")
    static let accentGreen = Color(hex: "#3CFF9E")
    static let accentRed = Color(hex: "#FF4D4D")
    static let accentBlue = Color(hex: "#3B82FF")
    static let accentPurple = Color(hex: "#B47CFF")
    static let accentYellow = Color(hex: "#FFE066")
    static let accentOrange = Color(hex: "#FB923C")

    // semantic aliases
    static let accent = accentCyan
    static let success = accentGreen
    static let warning = accentYellow
    static let error = accentRed

    // tonal variants used across chips/surfaces
    static let accentCyanSoft = accentCyan.opacity(0.22)
    static let accentGreenSoft = accentGreen.opacity(0.22)
    static let accentRedSoft = accentRed.opacity(0.22)
    static let accentPurpleSoft = accentPurple.opacity(0.22)

    static let overlayBlack50 = Color.black.opacity(0.5)
    static let overlayBlack60 = Color.black.opacity(0.6)
    static let trackWhite05 = Color.white.opacity(0.05)
    static let trackWhite15 = Color.white.opacity(0.15)

    static let cardGlow = accentCyan.opacity(0.24)
    static let interactiveGlow = accentCyan.opacity(0.35)
    static let botGlow = accentPurple.opacity(0.20)

    static let spotify = Color(hex: "#1DB954")
    static let spotifyHover = Color(hex: "#1ED760")
    static let errorBanner = Color(hex: "#1A0A0A")
}

extension Color {
    init(hex: String) {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let r, g, b: Double
        if cleaned.count == 6 {
            r = Double((value >> 16) & 0xFF) / 255
            g = Double((value >> 8) & 0xFF) / 255
            b = Double(value & 0xFF) / 255
        } else {
            r = 1
            g = 1
            b = 1
        }
        self.init(red: r, green: g, blue: b)
    }
}
