// ViewComponents.swift — Reusable view components for MenuLens
// Pixel+Muse — menu cards, annotation modifier, section container

import SwiftUI

// MARK: - Annotation Modifier

struct AnnotationModifier: ViewModifier {
    let text: String
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            content
            Text(text)
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
        }
    }
}

extension View {
    func annotation(_ text: String) -> some View {
        modifier(AnnotationModifier(text: text))
    }
}

// MARK: - App Section

struct AppSection<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content

    init(_ title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            if let title {
                Text(title)
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(.secondary)
            }
            content()
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
    }
}

// MARK: - Scan Result Badge

struct ScanResultBadge: View {
    let text: String
    let confidence: Double

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Circle()
                .fill(confidenceColor)
                .frame(width: 8, height: 8)
            Text(text)
                .font(AppTypography.caption)
        }
        .padding(.horizontal, DesignTokens.Spacing.sm)
        .padding(.vertical, DesignTokens.Spacing.xs)
        .background(.ultraThinMaterial, in: Capsule())
    }

    private var confidenceColor: Color {
        confidence > 0.8 ? .green : confidence > 0.5 ? .orange : .red
    }
}
