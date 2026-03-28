// MenuLensTheme.swift — Semantic theme layer built on DesignTokens
// Pixel+Muse — camera-first visual language

import SwiftUI

enum MenuLensTheme {

    // MARK: - Surface Styles
    enum Surface {
        static let card = RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
        static let sheet = RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
        static let scanFrame = RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
    }

    // MARK: - Shadows
    enum Shadow {
        static func card(_ scheme: ColorScheme) -> some ShapeStyle {
            scheme == .dark
                ? Color.black.opacity(0.4)
                : Color.black.opacity(0.08)
        }
    }

    // MARK: - Scan Overlay Colors
    enum Scan {
        static let frameBorder = Color.green.opacity(0.8)
        static let recognizedHighlight = Color.green.opacity(0.3)
        static let allergenHighlight = Color.red.opacity(0.4)
        static let overlayBackground = Color.black.opacity(0.45)
    }

    // MARK: - Haptic Presets
    enum Haptics {
        static func scanComplete() {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        static func itemTapped() {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        static func allergenWarning() {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
    }
}
