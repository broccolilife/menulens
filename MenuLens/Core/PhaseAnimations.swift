// PhaseAnimations.swift — iOS 17+ PhaseAnimator patterns for MenuLens
// Pixel+Muse — scanning & recognition motion patterns

import SwiftUI

// MARK: - Scan Line Animation

@available(iOS 17.0, *)
struct ScanLinePhase: View {
    var body: some View {
        Rectangle()
            .fill(.linearGradient(
                colors: [.clear, .green.opacity(0.4), .clear],
                startPoint: .leading, endPoint: .trailing
            ))
            .frame(height: 2)
            .phaseAnimator([0.0, 1.0]) { line, progress in
                line.offset(y: progress * 300 - 150)
            } animation: { _ in
                .easeInOut(duration: 1.8)
            }
    }
}

// MARK: - Shimmer Loading Phase

@available(iOS 17.0, *)
struct ShimmerPhase: ViewModifier {
    func body(content: Content) -> some View {
        content
            .phaseAnimator([false, true]) { view, shimmer in
                view.opacity(shimmer ? 0.4 : 1.0)
            } animation: { _ in
                .easeInOut(duration: 1.0)
            }
    }
}

// MARK: - Recognition Pulse

@available(iOS 17.0, *)
struct RecognitionPulse: ViewModifier {
    enum Phase: CaseIterable {
        case idle, pulse, settle
    }

    func body(content: Content) -> some View {
        content
            .phaseAnimator(Phase.allCases) { view, phase in
                view
                    .scaleEffect(phase == .pulse ? 1.08 : 1.0)
                    .brightness(phase == .pulse ? 0.1 : 0)
            } animation: { phase in
                switch phase {
                case .idle: .easeOut(duration: 0.3)
                case .pulse: .bouncy(duration: 0.4, extraBounce: 0.3)
                case .settle: .easeOut(duration: 0.5)
                }
            }
    }
}

// MARK: - View Extensions

@available(iOS 17.0, *)
extension View {
    func shimmerLoading() -> some View {
        modifier(ShimmerPhase())
    }

    func recognitionPulse() -> some View {
        modifier(RecognitionPulse())
    }
}
