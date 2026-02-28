// ViewComponents.swift — Shared UI Components for MenuLens
// From Pixel knowledge: view decomposition, reusable patterns

import SwiftUI

// MARK: - Dietary Badge

struct DietaryBadge: View {
    enum DietaryType: String {
        case vegan = "Vegan"
        case vegetarian = "Vegetarian"
        case halal = "Halal"
        case glutenFree = "Gluten Free"
        case dairyFree = "Dairy Free"

        var color: Color {
            switch self {
            case .vegan: return DesignTokens.Colors.veganBadge
            case .vegetarian: return DesignTokens.Colors.vegetarianBadge
            case .halal: return DesignTokens.Colors.halalBadge
            case .glutenFree: return .brown
            case .dairyFree: return .blue
            }
        }

        var icon: String {
            switch self {
            case .vegan: return "leaf.fill"
            case .vegetarian: return "leaf"
            case .halal: return "checkmark.seal.fill"
            case .glutenFree: return "wheat"
            case .dairyFree: return "drop.fill"
            }
        }
    }

    let type: DietaryType

    var body: some View {
        Label(type.rawValue, systemImage: type.icon)
            .font(.caption2.bold())
            .padding(.horizontal, DesignTokens.Spacing.xs)
            .padding(.vertical, DesignTokens.Spacing.xxxs)
            .background(type.color.opacity(0.15), in: Capsule())
            .foregroundStyle(type.color)
            .accessibilityLabel(type.rawValue)
    }
}

// MARK: - Allergen Warning Banner

struct AllergenWarningBanner: View {
    let allergens: [String]

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(DesignTokens.Colors.allergenWarning)
            Text("Contains: \(allergens.joined(separator: ", "))")
                .font(.caption.bold())
                .foregroundStyle(DesignTokens.Colors.allergenWarning)
        }
        .padding(DesignTokens.Spacing.sm)
        .background(DesignTokens.Colors.allergenWarning.opacity(0.1),
                     in: RoundedRectangle(cornerRadius: DesignTokens.Radius.sm))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Allergen warning: contains \(allergens.joined(separator: ", "))")
    }
}

// MARK: - Scan Result Card

struct ScanResultCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            content()
        }
        .padding(DesignTokens.Spacing.md)
        .background(DesignTokens.Colors.surfacePrimary,
                     in: RoundedRectangle(cornerRadius: DesignTokens.Radius.card))
        .elevation(DesignTokens.Elevation.scanResult)
    }
}

// MARK: - Translation Badge

struct TranslationBadge: View {
    let originalText: String
    let translatedText: String
    let targetLanguage: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
            Text(translatedText)
                .font(.body.bold())
                .foregroundStyle(DesignTokens.Colors.translationAccent)
            Text(originalText)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(translatedText), translated from \(originalText)")
    }
}
