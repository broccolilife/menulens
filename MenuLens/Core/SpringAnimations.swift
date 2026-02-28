import SwiftUI

// MARK: - Spring Animation Presets
/// Motion design tokens for MenuLens.
/// Tuned for camera/scanning UX — responsive feedback with subtle physicality.

enum AppAnimation {

    // MARK: - Base Springs
    static let gentleSpring = Animation.spring(duration: 0.5, bounce: 0.2)
    static let bouncySpring = Animation.spring(duration: 0.6, bounce: 0.4)
    static let snappySpring = Animation.spring(duration: 0.35, bounce: 0.15)
    static let softSpring = Animation.spring(duration: 0.7, bounce: 0.1)

    // MARK: - Semantic: Scanner
    static let scannerFocus = Animation.spring(duration: 0.3, bounce: 0.1)
    static let scanResultReveal = Animation.spring(duration: 0.5, bounce: 0.25)
    static let scanHighlight = Animation.spring(duration: 0.4, bounce: 0.2)

    // MARK: - Semantic: UI
    static let cardExpand = Animation.spring(duration: 0.45, bounce: 0.2)
    static let sheetPresent = Animation.spring(duration: 0.5, bounce: 0.15)
    static let tabSwitch = Animation.spring(duration: 0.3, bounce: 0.15)
    static let badgePop = Animation.spring(duration: 0.4, bounce: 0.5)
    static let listInsert = Animation.spring(duration: 0.4, bounce: 0.2)

    // MARK: - Micro-interactions
    static let buttonPress = Animation.spring(duration: 0.2, bounce: 0.3)
    static let iconPop = Animation.spring(duration: 0.4, bounce: 0.5)
}

// MARK: - View Modifiers

struct BounceOnAppear: ViewModifier {
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(appeared ? 1 : 0.5)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(AppAnimation.bouncySpring) {
                    appeared = true
                }
            }
    }
}

struct PressableButton: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1)
            .animation(AppAnimation.buttonPress, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

struct ScanRevealEffect: ViewModifier {
    @State private var revealed = false

    func body(content: Content) -> some View {
        content
            .offset(y: revealed ? 0 : 20)
            .opacity(revealed ? 1 : 0)
            .onAppear {
                withAnimation(AppAnimation.scanResultReveal) {
                    revealed = true
                }
            }
    }
}

struct ScannerPulse: ViewModifier {
    @State private var pulsing = false

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .stroke(DesignTokens.Colors.scannerHighlight, lineWidth: 2)
                    .scaleEffect(pulsing ? 1.02 : 1.0)
                    .opacity(pulsing ? 0.6 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulsing)
            )
            .onAppear { pulsing = true }
    }
}

// MARK: - View Extensions

extension View {
    func bounceOnAppear() -> some View {
        modifier(BounceOnAppear())
    }

    func pressable() -> some View {
        modifier(PressableButton())
    }

    func scanReveal() -> some View {
        modifier(ScanRevealEffect())
    }

    func scannerPulse() -> some View {
        modifier(ScannerPulse())
    }
}
