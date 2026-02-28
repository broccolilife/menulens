import SwiftUI

// MARK: - Typography System
/// Semantic type scale for MenuLens.
/// Clean, readable fonts optimized for scanned text display.

enum AppTypography {

    // MARK: - Display
    static let displayLarge = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
    static let displaySmall = Font.system(size: 24, weight: .semibold, design: .rounded)

    // MARK: - Headings
    static let headingLarge = Font.system(.title, design: .rounded, weight: .semibold)
    static let headingMedium = Font.system(.title2, design: .rounded, weight: .semibold)
    static let headingSmall = Font.system(.title3, design: .rounded, weight: .medium)

    // MARK: - Body
    static let bodyLarge = Font.system(.body, design: .default, weight: .regular)
    static let bodyMedium = Font.system(.callout, design: .default, weight: .regular)
    static let bodySmall = Font.system(.footnote, design: .default, weight: .regular)

    // MARK: - Labels
    static let labelLarge = Font.system(.body, design: .default, weight: .semibold)
    static let labelMedium = Font.system(.callout, design: .default, weight: .medium)
    static let labelSmall = Font.system(.caption, design: .default, weight: .medium)

    // MARK: - Special: Menu & Dish display
    static let dishName = Font.system(size: 22, weight: .semibold, design: .serif)
    static let dishDescription = Font.system(.callout, design: .default, weight: .regular)
    static let price = Font.system(size: 18, weight: .bold, design: .rounded)
    static let translatedText = Font.system(.body, design: .default, weight: .medium)
    static let originalText = Font.system(.callout, design: .serif, weight: .regular)
    static let allergenTag = Font.system(.caption2, design: .rounded, weight: .bold)
    static let scanInstruction = Font.system(.subheadline, design: .rounded, weight: .medium)
}

// MARK: - Text Style Modifier
struct AppTextStyle: ViewModifier {
    let font: Font
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
    }
}

extension View {
    func textStyle(_ font: Font, color: Color = DesignTokens.Colors.textPrimary) -> some View {
        modifier(AppTextStyle(font: font, color: color))
    }
}
