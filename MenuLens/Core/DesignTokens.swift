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

        static func scaled(_ base: CGFloat, relativeTo style: Font.TextStyle = .body) -> CGFloat {
            UIFontMetrics(forTextStyle: style.uiKit).scaledValue(for: base)
        }
    }

    // MARK: - Corner Radii
    enum Radius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 6
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let card: CGFloat = 20
        static let full: CGFloat = 9999

        static func continuous(_ radius: CGFloat) -> RoundedRectangle {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
        }
    }

    // MARK: - Semantic Colors
    enum Colors {
        // Surfaces
        static let primary = Color("AccentColor")
        static let secondary = Color.secondary
        static let background = Color(.systemBackground)
        static let surfacePrimary = Color(.secondarySystemBackground)
        static let surfaceSecondary = Color(.tertiarySystemBackground)
        static let surfaceElevated = Color(.systemBackground)

        // Text
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let textTertiary = Color(.tertiaryLabel)
        static let textOnPrimary = Color.white

        // Scanner-specific
        static let scannerHighlight = Color.blue
        static let scannerActive = Color.green
        static let scannerFrame = Color.white.opacity(0.8)
        static let ocrConfidenceHigh = Color.green
        static let ocrConfidenceMedium = Color.orange
        static let ocrConfidenceLow = Color.red

        // Menu/dish
        static let allergenWarning = Color.orange
        static let vegetarian = Color.green
        static let spicy = Color.red
        static let priceTag = Color(.label)

        // Interactive
        static let interactive = Color.accentColor
        static let interactivePressed = Color.accentColor.opacity(0.7)
        static let destructive = Color.red
        static let success = Color.green

        // Separators
        static let separator = Color(.separator)
        static let opaqueSeparator = Color(.opaqueSeparator)
    }

    // MARK: - Elevation
    enum Elevation {
        case flat, raised, floating, overlay

        var shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            switch self {
            case .flat:     return (.clear, 0, 0, 0)
            case .raised:   return (.black.opacity(0.08), 4, 0, 2)
            case .floating: return (.black.opacity(0.15), 12, 0, 6)
            case .overlay:  return (.black.opacity(0.25), 24, 0, 12)
            }
        }

        var background: Color {
            switch self {
            case .flat:     return Colors.background
            case .raised:   return Colors.surfacePrimary
            case .floating: return Colors.surfaceElevated
            case .overlay:  return Colors.surfaceElevated
            }
        }
    }

    // MARK: - Motion
    enum Motion {
        static let instant: Animation = .easeOut(duration: 0.1)
        static let quick: Animation = .easeOut(duration: 0.15)
        static let standard: Animation = .easeInOut(duration: 0.3)
        static let slow: Animation = .easeInOut(duration: 0.5)

        static let springSnappy: Animation = .spring(response: 0.2, dampingFraction: 0.7)
        static let springDefault: Animation = .spring(response: 0.4, dampingFraction: 0.75)
        static let springBouncy: Animation = .bouncy(duration: 0.5, extraBounce: 0.25)
        static let springGentle: Animation = .spring(response: 0.55, dampingFraction: 0.9)
    }

    // MARK: - Opacity
    enum Opacity {
        static let disabled: Double = 0.38
        static let secondary: Double = 0.6
        static let overlay: Double = 0.8
        static let full: Double = 1.0
        static let scrim: Double = 0.4
        static let cameraOverlay: Double = 0.7
    }

    // MARK: - Layout
    enum Layout {
        static let maxContentWidth: CGFloat = 428
        static let buttonHeight: CGFloat = 50
        static let buttonHeightCompact: CGFloat = 36
        static let hitTarget: CGFloat = 44
        static let scannerViewfinderInset: CGFloat = 32
        static let dishCardMinHeight: CGFloat = 72
        static let cameraControlsHeight: CGFloat = 100
    }

    // MARK: - Duration
    enum Duration {
        static let instant: TimeInterval = 0.1
        static let fast: TimeInterval = 0.2
        static let normal: TimeInterval = 0.3
        static let slow: TimeInterval = 0.5
        static let scanFeedback: TimeInterval = 0.15
    }
}

// MARK: - Elevation View Modifier

extension View {
    func elevation(_ level: DesignTokens.Elevation) -> some View {
        let s = level.shadow
        return self
            .background(level.background, in: DesignTokens.Radius.continuous(DesignTokens.Radius.card))
            .shadow(color: s.color, radius: s.radius, x: s.x, y: s.y)
    }
}

// MARK: - UIKit Bridge

private extension Font.TextStyle {
    var uiKit: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title:      return .title1
        case .title2:     return .title2
        case .title3:     return .title3
        case .headline:   return .headline
        case .body:       return .body
        case .callout:    return .callout
        case .subheadline: return .subheadline
        case .footnote:   return .footnote
        case .caption:    return .caption1
        case .caption2:   return .caption2
        @unknown default: return .body
        }
    }
}
