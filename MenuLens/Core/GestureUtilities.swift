// GestureUtilities.swift — Gesture patterns for MenuLens
// Pixel+Muse — camera/menu interaction gestures with spring feedback

import SwiftUI

// MARK: - Tap Bounce

struct TapBounce: ViewModifier {
    let action: () -> Void
    @State private var tapped = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(tapped ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: tapped)
            .onTapGesture {
                tapped = true
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { tapped = false }
            }
    }
}

// MARK: - Long Press Scale

struct LongPressScale: ViewModifier {
    let minimumDuration: Double
    let action: () -> Void
    @State private var pressing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(pressing ? 0.92 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: pressing)
            .onLongPressGesture(minimumDuration: minimumDuration) {
                action()
            } onPressingChanged: { pressing = $0 }
    }
}

// MARK: - Pinch to Zoom (for menu images)

struct PinchZoom: ViewModifier {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { scale = lastScale * $0 }
                    .onEnded { _ in
                        lastScale = max(1.0, min(scale, 3.0))
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            scale = lastScale
                        }
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    scale = 1.0; lastScale = 1.0
                }
            }
    }
}

extension View {
    func tapBounce(action: @escaping () -> Void) -> some View {
        modifier(TapBounce(action: action))
    }
    func longPressScale(minimumDuration: Double = 0.3, action: @escaping () -> Void) -> some View {
        modifier(LongPressScale(minimumDuration: minimumDuration, action: action))
    }
    func pinchZoom() -> some View {
        modifier(PinchZoom())
    }
}
