// MenuItemCard.swift — Reusable menu item display component
// Pixel+Muse — design token-driven card layout

import SwiftUI

struct MenuItemCard: View {
    let item: MenuItem
    let showAllergens: Bool

    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack {
                Text(item.name)
                    .font(AppTypography.headline)
                Spacer()
                if let price = item.price {
                    Text(price)
                        .font(AppTypography.monoCaption)
                        .foregroundStyle(.secondary)
                }
            }

            if let desc = item.description {
                Text(desc)
                    .font(AppTypography.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            if showAllergens && !item.allergens.isEmpty {
                HStack(spacing: DesignTokens.Spacing.xxs) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                    Text(item.allergens.joined(separator: ", "))
                        .font(AppTypography.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(
            MenuLensTheme.Surface.card
                .fill(.regularMaterial)
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .onAppear {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                appeared = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    private var accessibilityDescription: String {
        var parts = [item.name]
        if let price = item.price { parts.append(price) }
        if let desc = item.description { parts.append(desc) }
        if showAllergens && !item.allergens.isEmpty {
            parts.append("Allergens: \(item.allergens.joined(separator: ", "))")
        }
        return parts.joined(separator: ". ")
    }
}

// MARK: - Dietary Filter Chips

struct DietaryFilterChips: View {
    let filters: [DietaryFilter]
    @Binding var selected: Set<DietaryFilter>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                ForEach(filters, id: \.self) { filter in
                    DietaryChip(
                        filter: filter,
                        isSelected: selected.contains(filter)
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if selected.contains(filter) {
                                selected.remove(filter)
                            } else {
                                selected.insert(filter)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
        }
    }
}

struct DietaryChip: View {
    let filter: DietaryFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: filter.icon)
                    .font(.caption2)
                Text(filter.label)
                    .font(AppTypography.caption)
            }
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(
                isSelected
                    ? AnyShapeStyle(filter.color.opacity(0.2))
                    : AnyShapeStyle(.ultraThinMaterial),
                in: Capsule()
            )
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? filter.color : .clear, lineWidth: 1)
            )
            .foregroundStyle(isSelected ? filter.color : .secondary)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

enum DietaryFilter: String, CaseIterable, Hashable {
    case vegetarian, vegan, glutenFree, dairyFree, nutFree, halal

    var label: String {
        switch self {
        case .vegetarian: "Vegetarian"
        case .vegan: "Vegan"
        case .glutenFree: "Gluten-Free"
        case .dairyFree: "Dairy-Free"
        case .nutFree: "Nut-Free"
        case .halal: "Halal"
        }
    }

    var icon: String {
        switch self {
        case .vegetarian: "leaf.fill"
        case .vegan: "leaf.circle.fill"
        case .glutenFree: "wheat.bundle.slash"
        case .dairyFree: "drop.triangle"
        case .nutFree: "xmark.circle"
        case .halal: "checkmark.seal.fill"
        }
    }

    var color: Color {
        switch self {
        case .vegetarian: .green
        case .vegan: .mint
        case .glutenFree: .orange
        case .dairyFree: .blue
        case .nutFree: .red
        case .halal: .purple
        }
    }
}
