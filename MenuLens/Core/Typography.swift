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
    static let labelMicro = Font.system(.caption2, design: .default, weight: .bold)

    // MARK: - Special: Menu & Dish display
    static let dishName = Font.system(size: 22, weight: .semibold, design: .serif)
    static let dishDescription = Font.system(.callout, design: .default, weight: .regular)
    static let price = Font.system(size: 18, weight: .bold, design: .rounded)
    static let priceSmall = Font.system(size: 14, weight: .semibold, design: .rounded)
    static let translatedText = Font.system(.body, design: .default, weight: .medium)
    static let originalText = Font.system(.callout, design: .serif, weight: .regular)
    static let allergenTag = Font.system(.caption2, design: .rounded, weight: .bold)
    static let scanInstruction = Font.system(.subheadline, design: .rounded, weight: .medium)

    // MARK: - Semantic Contexts
    enum Semantic {
        /// Camera overlay instruction text
        static let cameraGuide: Font = .system(size: 16, weight: .medium, design: .rounded)
        /// OCR confidence display
        static let confidence: Font = .system(size: 12, weight: .semibold, design: .monospaced)
        /// Calorie/nutrition data
        static let nutritionValue: Font = .system(size: 15, weight: .semibold, design: .monospaced)
        /// Restaurant name
        static let restaurantName: Font = .system(size: 20, weight: .bold, design: .default)
        /// Category headers in menu
        static let menuCategory: Font = .system(size: 18, weight: .semibold, design: .rounded)
        /// Button labels
        static let button: Font = .system(size: 16, weight: .semibold, design: .rounded)
    }

    // MARK: - Dynamic Type Scaling
    static func scaled(_ size: CGFloat, weight: Font.Weight = .regular,
                       design: Font.Design = .default, relativeTo style: Font.TextStyle = .body) -> Font {
        .system(size: size, weight: weight, design: design)
    }
}

// MARK: - Text Style Modifier

struct AppTextStyle: ViewModifier {
    let font: Font
    let color: Color
    let tracking: CGFloat
    let lineSpacing: CGFloat

    init(_ font: Font, color: Color = DesignTokens.Colors.textPrimary, tracking: CGFloat = 0, lineSpacing: CGFloat = 0) {
        self.font = font
        self.color = color
        self.tracking = tracking
        self.lineSpacing = lineSpacing
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .tracking(tracking)
            .lineSpacing(lineSpacing)
    }
}

// MARK: - View Extensions

extension View {
    func textStyle(_ font: Font, color: Color = DesignTokens.Colors.textPrimary, tracking: CGFloat = 0, lineSpacing: CGFloat = 0) -> some View {
        modifier(AppTextStyle(font, color: color, tracking: tracking, lineSpacing: lineSpacing))
    }

    /// Dish name — serif, warm
    func dishNameStyle() -> some View {
        modifier(AppTextStyle(AppTypography.dishName, tracking: -0.2))
    }

    /// Price tag — bold, rounded
    func priceStyle() -> some View {
        modifier(AppTextStyle(AppTypography.price, color: DesignTokens.Colors.priceTag))
    }

    /// Translated text emphasis
    func translatedStyle() -> some View {
        modifier(AppTextStyle(AppTypography.translatedText, color: DesignTokens.Colors.textPrimary, lineSpacing: 2))
    }

    /// Original foreign text (lighter, serif)
    func originalTextStyle() -> some View {
        modifier(AppTextStyle(AppTypography.originalText, color: DesignTokens.Colors.textSecondary))
    }
}

// MARK: - Text Convenience

extension Text {
    func dishName() -> Text {
        self.font(AppTypography.dishName)
    }

    func price() -> Text {
        self.font(AppTypography.price)
            .fontWeight(.bold)
    }

    func allergen() -> Text {
        self.font(AppTypography.allergenTag)
            .fontWeight(.bold)
    }

    func sectionHeader() -> Text {
        self.font(AppTypography.headingMedium)
            .foregroundColor(.secondary)
    }
}
