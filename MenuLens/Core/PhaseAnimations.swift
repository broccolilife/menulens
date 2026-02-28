// PhaseAnimations.swift — Phase-based animations for MenuLens
// From Pixel knowledge: SwiftUI phase animations for scan/capture UX

import SwiftUI

// MARK: - Scan Pulse Animation

struct ScanPulseModifier: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .opacity(isAnimating ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: isAnimating)
            .onAppear { isAnimating = true }
    }
}

// MARK: - Scanner Frame Animation

struct ScannerFrameAnimationModifier: ViewModifier {
    @State private var lineOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    Rectangle()
                        .fill(DesignTokens.Colors.scannerHighlight.opacity(0.4))
                        .frame(height: 2)
                        .offset(y: lineOffset)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                   value: lineOffset)
                        .onAppear { lineOffset = geo.size.height }
                }
            }
    }
}

// MARK: - Result Appear Animation

struct ResultAppearModifier: ViewModifier {
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: appeared)
            .onAppear { appeared = true }
    }
}

// MARK: - View Extensions

extension View {
    func scanPulse() -> some View {
        modifier(ScanPulseModifier())
    }

    func scannerFrameAnimation() -> some View {
        modifier(ScannerFrameAnimationModifier())
    }

    func resultAppear() -> some View {
        modifier(ResultAppearModifier())
    }
}
