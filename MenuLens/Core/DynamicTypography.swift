// DynamicTypography.swift — Enhanced type system with Dynamic Type & accessibility
// Pixel+Muse — responsive typography that scales properly

import SwiftUI

// MARK: - Responsive Font Scale

enum ResponsiveFont {
    /// Creates a font that respects Dynamic Type with a relative-to base
    static func scaled(_ style: Font.TextStyle, design: Font.Design = .default, weight: Font.Weight = .regular) -> Font {
        .system(style, design: design, weight: weight)
    }
    
    /// Display — hero text, max 2-3 words
    static let display = scaled(.largeTitle, design: .rounded, weight: .black)
    
    /// Title — section headers
    static let title = scaled(.title2, design: .rounded, weight: .bold)
    
    /// Subtitle — card headers, list titles
    static let subtitle = scaled(.headline, design: .rounded, weight: .semibold)
    
    /// Body — main content text
    static let body = scaled(.body, design: .default, weight: .regular)
    
    /// Callout — secondary content, hints
    static let callout = scaled(.callout, design: .default, weight: .regular)
    
    /// Caption — timestamps, labels, metadata
    static let caption = scaled(.caption, design: .default, weight: .medium)
    
    /// Overline — category labels, all-caps headers
    static let overline = scaled(.caption2, design: .rounded, weight: .semibold)
    
    /// Monospaced — numbers, codes, timers
    static let mono = scaled(.body, design: .monospaced, weight: .medium)
    
    /// Mono small — secondary numeric data
    static let monoSmall = scaled(.caption, design: .monospaced, weight: .regular)
}

// MARK: - Text Style Modifier with Line Spacing

struct ResponsiveTextStyle: ViewModifier {
    let font: Font
    let lineSpacing: CGFloat
    let tracking: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .lineSpacing(lineSpacing)
            .tracking(tracking)
    }
}

extension View {
    /// Apply responsive text style with proper line spacing
    func textStyle(_ font: Font, lineSpacing: CGFloat = 2, tracking: CGFloat = 0) -> some View {
        modifier(ResponsiveTextStyle(font: font, lineSpacing: lineSpacing, tracking: tracking))
    }
    
    /// Overline style — uppercased, wide-tracked
    func overlineStyle() -> some View {
        modifier(ResponsiveTextStyle(font: ResponsiveFont.overline, lineSpacing: 0, tracking: 1.5))
            .textCase(.uppercase)
    }
    
    /// Numeric display — tabular figures for alignment
    func numericStyle(_ font: Font = ResponsiveFont.mono) -> some View {
        self
            .font(font)
            .monospacedDigit()
    }
}

// MARK: - Accessibility-Aware Size Classes

struct AccessibleTypography: ViewModifier {
    @Environment(\.dynamicTypeSize) var typeSize
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    let compactFont: Font
    let regularFont: Font
    
    func body(content: Content) -> some View {
        content
            .font(typeSize.isAccessibilitySize ? compactFont : regularFont)
            .lineLimit(typeSize.isAccessibilitySize ? nil : 2)
    }
}

extension View {
    /// Auto-switch font at accessibility sizes for better readability
    func accessibleFont(compact: Font, regular: Font) -> some View {
        modifier(AccessibleTypography(compactFont: compact, regularFont: regular))
    }
    
    /// Ensure minimum readable size regardless of Dynamic Type setting
    func minimumReadableSize() -> some View {
        self.dynamicTypeSize(...DynamicTypeSize.accessibility3)
    }
}
