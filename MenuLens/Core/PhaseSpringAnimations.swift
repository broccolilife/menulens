// PhaseSpringAnimations.swift — Phase-based spring animation system
// Pixel+Muse — choreographed multi-step animations using PhaseAnimator

import SwiftUI

// MARK: - Breathing Animation (idle states)

struct BreathingModifier: ViewModifier {
    let intensity: CGFloat
    @State private var phase = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(phase ? 1.0 + intensity : 1.0)
            .opacity(phase ? 1.0 : 0.85)
            .animation(
                .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: phase
            )
            .onAppear { phase = true }
    }
}

// MARK: - Cascade Reveal (list items)

struct CascadeReveal: ViewModifier {
    let index: Int
    let totalItems: Int
    @State private var revealed = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: revealed ? 0 : 20)
            .opacity(revealed ? 1 : 0)
            .blur(radius: revealed ? 0 : 2)
            .onAppear {
                withAnimation(
                    .spring(response: 0.5, dampingFraction: 0.75)
                    .delay(Double(index) * 0.06)
                ) {
                    revealed = true
                }
            }
    }
}

// MARK: - Elastic Counter (score/number changes)

struct ElasticCounter: ViewModifier {
    let value: Int
    @State private var bouncing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bouncing ? 1.2 : 1.0)
            .onChange(of: value) { _, _ in
                bouncing = true
                withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                    bouncing = false
                }
            }
    }
}

// MARK: - Morphing Shape Transition

struct MorphTransition: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(
                cornerRadius: isActive ? 12 : 24,
                style: .continuous
            ))
            .scaleEffect(isActive ? 1.0 : 0.9)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isActive)
    }
}

// MARK: - View Extensions

extension View {
    /// Subtle breathing animation for idle/waiting states
    func breathing(intensity: CGFloat = 0.03) -> some View {
        modifier(BreathingModifier(intensity: intensity))
    }
    
    /// Staggered reveal with blur transition
    func cascadeReveal(index: Int, total: Int = 10) -> some View {
        modifier(CascadeReveal(index: index, totalItems: total))
    }
    
    /// Elastic bounce on value change (scores, counters)
    func elasticCounter(value: Int) -> some View {
        modifier(ElasticCounter(value: value))
    }
    
    /// Morph between rounded states
    func morphTransition(isActive: Bool) -> some View {
        modifier(MorphTransition(isActive: isActive))
    }
}

// MARK: - Interaction Feedback Springs

enum InteractionSpring {
    /// Drag release — object snaps back
    static let dragRelease: Animation = .spring(response: 0.35, dampingFraction: 0.55)
    
    /// Long press confirm — satisfying settle
    static let longPressConfirm: Animation = .spring(response: 0.4, dampingFraction: 0.6)
    
    /// Swipe dismiss — fast exit
    static let swipeDismiss: Animation = .spring(response: 0.25, dampingFraction: 0.8)
    
    /// Rotation snap — for angle-locking interactions
    static let rotationSnap: Animation = .spring(response: 0.3, dampingFraction: 0.65)
    
    /// Parallax shift — subtle depth motion
    static let parallaxShift: Animation = .spring(response: 0.6, dampingFraction: 0.9)
}
