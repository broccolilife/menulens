// Accessibility.swift — Accessibility Utilities & View Modifiers for MenuLens
// From Pixel knowledge: every interactive element needs accessibilityLabel,
// accessibilityAction for custom gestures, Dynamic Type support

import SwiftUI

// MARK: - Accessibility Helpers

extension View {
    /// Annotation modifier with accessibility support
    func annotation(_ text: String) -> some View {
        modifier(AnnotationModifier(text: text))
    }

    /// Semantic card grouping with accessibility
    func accessibleCard(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }

    /// Menu item accessibility — combines dish name, price, allergens
    func accessibleMenuItem(name: String, price: String?, allergens: [String] = []) -> some View {
        let allergenText = allergens.isEmpty ? "" : " Contains \(allergens.joined(separator: ", "))."
        let priceText = price.map { " \($0)" } ?? ""
        return self
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(name)\(priceText).\(allergenText)")
    }
}

// MARK: - Annotation Modifier

struct AnnotationModifier: ViewModifier {
    let text: String

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityLabel(text)
        }
    }
}

// MARK: - Reusable Section Pattern

struct AppSection<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            if let title {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .accessibilityAddTraits(.isHeader)
            }
            content()
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
    }
}

// MARK: - Haptic Feedback

enum HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - Scanner Accessibility

extension View {
    /// Adds VoiceOver announcement for scan results
    func announceScanResult(_ text: String) -> some View {
        self.onChange(of: text) { _, newValue in
            guard !newValue.isEmpty else { return }
            UIAccessibility.post(notification: .announcement,
                                 argument: "Scan complete. \(newValue)")
        }
    }
}
