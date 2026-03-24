import SwiftUI

// MARK: - Typography System for MenuLens

/// Semantic type styles with Dynamic Type support.
/// Clean, legible system for scanning/reading menus.

enum AppTypography {

    // MARK: - Display & Headings

    /// Display — restaurant name, splash title
    static let display = Font.system(.largeTitle, weight: .bold)

    /// Title — screen titles
    static let title = Font.system(.title2, weight: .bold)

    /// Subtitle — section headers
    static let subtitle = Font.system(.title3, weight: .semibold)

    /// Headline — dish names, card headers
    static let headline = Font.system(.headline, weight: .semibold)

    // MARK: - Body & Detail

    /// Body — descriptions, ingredient lists
    static let body = Font.system(.body)

    /// Callout — allergen notes, tips
    static let callout = Font.system(.callout)

    /// Caption — scanned metadata, confidence
    static let caption = Font.system(.caption)

    /// Micro — badges, tiny labels
    static let micro = Font.system(.caption2, weight: .medium)

    // MARK: - Specialized

    /// Price — prominent, monospaced digits for dish prices
    static let price = Font.system(.title3, design: .rounded, weight: .bold)

    /// OCR result — monospaced for raw scan text
    static let ocrRaw = Font.system(.body, design: .monospaced)

    /// Allergen tag — small, bold for warning badges
    static let allergenTag = Font.system(.caption, weight: .bold)

    /// Calorie — rounded for nutrition stats
    static let nutrition = Font.system(.headline, design: .rounded, weight: .semibold)

    // MARK: - Line Heights

    static let tightLeading: CGFloat = 1.1
    static let normalLeading: CGFloat = 1.4
    static let relaxedLeading: CGFloat = 1.6

    // MARK: - Tracking

    static let tightTracking: CGFloat = -0.5
    static let normalTracking: CGFloat = 0
    static let wideTracking: CGFloat = 1.0
}

// MARK: - View Modifiers

extension View {
    func textStyle(_ font: Font, color: Color = DesignTokens.Colors.textPrimary) -> some View {
        self
            .font(font)
            .foregroundStyle(color)
    }

    /// Dish name style with primary emphasis.
    func dishNameStyle() -> some View {
        self
            .font(AppTypography.headline)
            .foregroundStyle(DesignTokens.Colors.textPrimary)
    }

    /// Price display — rounded, prominent.
    func priceStyle() -> some View {
        self
            .font(AppTypography.price)
            .monospacedDigit()
            .foregroundStyle(DesignTokens.Colors.priceTag)
    }

    /// Allergen warning badge text.
    func allergenTagStyle() -> some View {
        self
            .font(AppTypography.allergenTag)
            .foregroundStyle(DesignTokens.Colors.allergenWarning)
            .textCase(.uppercase)
            .tracking(AppTypography.wideTracking)
    }

    /// Nutrition stat readout.
    func nutritionStyle() -> some View {
        self
            .font(AppTypography.nutrition)
            .monospacedDigit()
    }
}

// MARK: - Text Convenience

extension Text {
    func captionSecondary() -> Text {
        self
            .font(AppTypography.caption)
            .foregroundStyle(DesignTokens.Colors.textSecondary)
    }

    func ocrResultStyle() -> Text {
        self
            .font(AppTypography.ocrRaw)
            .foregroundStyle(DesignTokens.Colors.textSecondary)
    }
}
