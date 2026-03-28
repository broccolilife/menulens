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
    }
}
