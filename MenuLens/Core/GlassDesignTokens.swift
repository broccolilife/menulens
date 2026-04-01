// GlassDesignTokens.swift — iOS 26 Glass-Ready Design Extensions
// Pixel+Muse — Liquid Glass preparation & adaptive materials

import SwiftUI

// MARK: - Glass Materials (iOS 26 Preparation)

enum GlassMaterial {
    
    /// Thin frosted overlay for floating controls
    static let thinFrost: Material = .ultraThinMaterial
    
    /// Standard card background — transitions to glassEffect in iOS 26
    static let cardSurface: Material = .regularMaterial
    
    /// Thick frosted panel for modals and sheets
    static let thickPanel: Material = .thickMaterial
    
    /// Bar material for nav/tab bars — auto-glass in iOS 26
    static let barMaterial: Material = .bar
}

// MARK: - Adaptive Color Tokens

enum AdaptiveColor {
    /// Vibrant label that adapts to material backgrounds
    static let vibrantPrimary = Color.primary
    
    /// Tinted surface that works on glass and solid backgrounds
    static let tintedSurface = Color.accentColor.opacity(0.12)
    
    /// Separator that's visible on both glass and solid
    static let adaptiveSeparator = Color(.separator)
    
    /// Subtle fill for interactive states
    static let interactiveFill = Color(.systemFill)
    
    /// Quaternary fill for subtle backgrounds
    static let subtleFill = Color(.quaternarySystemFill)
}

// MARK: - Glass-Ready View Modifiers

extension View {
    /// Card style that's ready for iOS 26 liquid glass
    func glassCard(radius: CGFloat = 16) -> some View {
        self
            .padding(DesignTokens.Spacing.md)
            .background(GlassMaterial.cardSurface, in: .rect(cornerRadius: radius, style: .continuous))
    }
    
    /// Floating control bar with thin frost
    func floatingBar() -> some View {
        self
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(GlassMaterial.thinFrost, in: Capsule())
    }
    
    /// Vibrancy effect for text on material backgrounds
    func vibrantText() -> some View {
        self
            .foregroundStyle(.primary)
            .environment(\.colorScheme, .dark) // ensures contrast on translucent
    }
}

// MARK: - Accessibility Contrast Tokens

enum AccessibilityTokens {
    /// Minimum contrast ratio boundaries (WCAG AA)
    static let minContrastRatio: CGFloat = 4.5
    
    /// High-contrast border for increase contrast mode
    static let highContrastBorder = Color(.label).opacity(0.3)
    
    /// Accessible focus ring
    static let focusRingColor = Color.accentColor
    static let focusRingWidth: CGFloat = 3
}

extension View {
    /// Add accessible focus ring when element is focused
    @ViewBuilder
    func accessibleFocusRing(_ isFocused: Bool) -> some View {
        if isFocused {
            self.overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md, style: .continuous)
                    .strokeBorder(AccessibilityTokens.focusRingColor, lineWidth: AccessibilityTokens.focusRingWidth)
            )
        } else {
            self
        }
    }
}
