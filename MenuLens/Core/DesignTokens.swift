import SwiftUI

// MARK: - Design Tokens
/// Centralized design tokens for MenuLens.
/// 8pt grid, semantic colors tuned for camera/scanning UX.

enum DesignTokens {

    // MARK: - Spacing (8pt grid)
    enum Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }

    // MARK: - Corner Radii
    enum Radius {
        static let sm: CGFloat = 6
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let card: CGFloat = 20
        static let full: CGFloat = 9999
    }

    // MARK: - Semantic Colors
    enum Colors {
        static let primary = Color("AccentColor")
        static let secondary = Color.secondary
        static let background = Color(.systemBackground)
        static let surfacePrimary = Color(.secondarySystemBackground)
        static let surfaceSecondary = Color(.tertiarySystemBackground)
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textTertiary = Color(.tertiaryLabel)
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red

        // App-specific: scanning & food UX
        static let scannerOverlay = Color.black.opacity(0.6)
        static let scannerFrame = Color.white
        static let scannerHighlight = Color.mint
        static let allergenWarning = Color.red.opacity(0.9)
        static let veganBadge = Color.green
        static let vegetarianBadge = Color.mint
        static let halalBadge = Color.teal
        static let translationAccent = Color.indigo
    }

    // MARK: - Elevation
    enum Elevation {
        static let card = ShadowStyle(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        static let sheet = ShadowStyle(color: .black.opacity(0.15), radius: 20, x: 0, y: -4)
        static let scanResult = ShadowStyle(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
    }

    // MARK: - Icon Sizes
    enum IconSize {
        static let sm: CGFloat = 16
        static let md: CGFloat = 24
        static let lg: CGFloat = 32
        static let xl: CGFloat = 48
        static let scanButton: CGFloat = 64
    }
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

extension View {
    func elevation(_ style: ShadowStyle) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
