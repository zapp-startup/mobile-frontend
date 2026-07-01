import SwiftUI

enum AppColors {
    // Refined dark: warm near-black graphite-navy, layered surfaces (depth via tone + border, not glow).
    static let background = Color(hex: "#0A0E16")
    static let elevated = Color(hex: "#141A24")
    static let subtle = Color(hex: "#1B2230")
    static let inset = Color(hex: "#070A11")

    // Softer-than-pure white reads calmer at title weights.
    static let textPrimary = Color(hex: "#F4F6FB")
    static let textSecondary = Color(hex: "#AEB8C7")
    static let textMuted = Color(hex: "#727E90")
    static let textFaint = Color(hex: "#4B5563")
    static let textInverse = Color(hex: "#070A11")

    static let borderSubtle = Color.white.opacity(0.07)
    static let borderStrong = Color.white.opacity(0.14)
    static let borderFocus = Color(hex: "#38E0C8")
    static let borderMuted = borderSubtle

    // One brand accent (teal). The rest are demoted to status-only, all toned down from neon.
    static let accentCyan = Color(hex: "#38E0C8")
    static let accentTeal = Color(hex: "#2FD3B8")
    static let accentGreen = Color(hex: "#3DD68C")
    static let accentRed = Color(hex: "#FF6B6B")
    static let accentBlue = Color(hex: "#5B8DEF")
    static let accentPurple = Color(hex: "#9B8CFF")
    static let accentYellow = Color(hex: "#F2C572")
    static let accentOrange = Color(hex: "#F0A05A")

    // semantic aliases
    static let accent = accentCyan
    static let success = accentGreen
    static let warning = accentYellow
    static let error = accentRed

    // tonal variants used across chips/surfaces
    static let accentCyanSoft = accentCyan.opacity(0.16)
    static let accentGreenSoft = accentGreen.opacity(0.16)
    static let accentRedSoft = accentRed.opacity(0.16)
    static let accentPurpleSoft = accentPurple.opacity(0.16)

    static let overlayBlack50 = Color.black.opacity(0.5)
    static let overlayBlack60 = Color.black.opacity(0.6)
    static let trackWhite05 = Color.white.opacity(0.05)
    static let trackWhite15 = Color.white.opacity(0.15)

    // Glows softened: subtle presence, not neon halos.
    static let cardGlow = accentCyan.opacity(0.10)
    static let interactiveGlow = accentCyan.opacity(0.16)
    static let botGlow = accentPurple.opacity(0.10)

    static let spotify = Color(hex: "#1DB954")
    static let spotifyHover = Color(hex: "#1ED760")
    static let errorBanner = Color(hex: "#1A0A0A")
}

extension Color {
    /// Supports #RGB, #RRGGBB, and #RRGGBBAA. Falls back to clear (not white) on bad input.
    init(hex: String) {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        var value: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&value) else {
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
            return
        }

        let r, g, b, a: Double
        switch cleaned.count {
        case 3:
            r = Double((value >> 8) & 0xF) / 15
            g = Double((value >> 4) & 0xF) / 15
            b = Double(value & 0xF) / 15
            a = 1
        case 6:
            r = Double((value >> 16) & 0xFF) / 255
            g = Double((value >> 8) & 0xFF) / 255
            b = Double(value & 0xFF) / 255
            a = 1
        case 8:
            r = Double((value >> 24) & 0xFF) / 255
            g = Double((value >> 16) & 0xFF) / 255
            b = Double((value >> 8) & 0xFF) / 255
            a = Double(value & 0xFF) / 255
        default:
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
            return
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
