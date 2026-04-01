// LiquidGlass.swift — iOS 26 Liquid Glass Preparation for MenuLens
// Pixel+Flow — glass effects for scanner overlays and floating controls

import SwiftUI

// MARK: - Glass Effect Utilities

extension View {
    /// Glass material card — ideal for menu item overlays on camera view
    func glassCard(cornerRadius: CGFloat = DesignTokens.Radius.card) -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
    }

    /// Floating action button with glass material
    func glassFAB() -> some View {
        self
            .font(.title2.bold())
            .frame(width: 56, height: 56)
            .background(.ultraThinMaterial, in: Circle())
            .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
            .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Scanner Overlay Glass

struct ScannerOverlayGlass: View {
    let dishName: String
    let confidence: Double

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            confidenceIndicator
            Text(dishName)
                .font(.headline)
                .foregroundStyle(.primary)
            Spacer()
        }
        .padding(DesignTokens.Spacing.md)
        .glassCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(dishName), confidence \(Int(confidence * 100)) percent")
    }

    @ViewBuilder
    private var confidenceIndicator: some View {
        Circle()
            .fill(confidenceColor)
            .frame(width: 10, height: 10)
            .accessibilityHidden(true)
    }

    private var confidenceColor: Color {
        switch confidence {
        case 0.8...: return DesignTokens.Colors.ocrConfidenceHigh
        case 0.5...: return DesignTokens.Colors.ocrConfidenceMedium
        default: return DesignTokens.Colors.ocrConfidenceLow
        }
    }
}

// MARK: - Mesh Gradient Background (iOS 18+)

struct MeshGradientBackground: View {
    let colors: [Color]
    @State private var animating = false

    var body: some View {
        if #available(iOS 18.0, *) {
            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [animating ? 0.6 : 0.4, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ],
                colors: colors.count >= 9 ? Array(colors.prefix(9)) : paddedColors
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    animating.toggle()
                }
            }
            .accessibilityHidden(true)
        } else {
            LinearGradient(colors: colors.prefix(2).map { $0 }, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .accessibilityHidden(true)
        }
    }

    private var paddedColors: [Color] {
        var padded = colors
        while padded.count < 9 { padded.append(padded.last ?? .clear) }
        return padded
    }
}
