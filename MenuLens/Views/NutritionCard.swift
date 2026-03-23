// NutritionCard.swift — Nutrition breakdown card for scanned menu items
// Pixel (Eva) — 2026-03-23

import SwiftUI

struct NutritionCard: View {
    let itemName: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let allergens: [String]
    let confidence: Double // 0-1 ML confidence score
    
    private var macroTotal: Double { protein + carbs + fat }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            header
            calorieDisplay
            macroBreakdown
            if !allergens.isEmpty {
                allergenTags
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var header: some View {
        HStack {
            Text(itemName)
                .font(AppTypography.cardTitle)
                .lineLimit(2)
            Spacer()
            confidenceBadge
        }
    }
    
    @ViewBuilder
    private var confidenceBadge: some View {
        let color: Color = confidence > 0.8 ? .green : confidence > 0.5 ? .orange : .red
        HStack(spacing: 3) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text("\(Int(confidence * 100))%")
                .font(.system(.caption2, design: .rounded, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(color.opacity(0.12), in: Capsule())
    }
    
    @ViewBuilder
    private var calorieDisplay: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("\(calories)")
                .font(.system(size: 36, weight: .semibold, design: .rounded))
            Text("kcal")
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var macroBreakdown: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            // Stacked bar
            GeometryReader { geo in
                HStack(spacing: 1) {
                    if macroTotal > 0 {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(.blue)
                            .frame(width: geo.size.width * protein / macroTotal)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(.orange)
                            .frame(width: geo.size.width * carbs / macroTotal)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(.yellow)
                            .frame(width: geo.size.width * fat / macroTotal)
                    }
                }
            }
            .frame(height: 8)
            .clipShape(Capsule())
            
            // Labels
            HStack {
                macroLabel("Protein", value: protein, color: .blue)
                Spacer()
                macroLabel("Carbs", value: carbs, color: .orange)
                Spacer()
                macroLabel("Fat", value: fat, color: .yellow)
            }
        }
    }
    
    @ViewBuilder
    private func macroLabel(_ name: String, value: Double, color: Color) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 0) {
                Text(String(format: "%.0fg", value))
                    .font(.system(.caption, design: .rounded, weight: .medium))
                Text(name)
                    .font(.system(.caption2))
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var allergenTags: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Allergens")
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
            
            FlowLayout(spacing: DesignTokens.Spacing.xs) {
                ForEach(allergens, id: \.self) { allergen in
                    Text(allergen)
                        .font(.system(.caption2, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.red.opacity(0.1), in: Capsule())
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

// MARK: - Simple Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(
                x: bounds.minX + result.positions[index].x,
                y: bounds.minY + result.positions[index].y
            ), proposal: .unspecified)
        }
    }
    
    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        
        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}

#Preview {
    NutritionCard(
        itemName: "Grilled Salmon Bowl",
        calories: 520,
        protein: 38,
        carbs: 42,
        fat: 18,
        allergens: ["Fish", "Soy", "Sesame"],
        confidence: 0.87
    )
    .padding()
}
