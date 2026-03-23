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
    static let ocrDetect = Animation.spring(duration: 0.25, bounce: 0.3)

    // MARK: - Semantic: UI
    static let cardExpand = Animation.spring(duration: 0.45, bounce: 0.2)
    static let sheetPresent = Animation.spring(duration: 0.5, bounce: 0.15)
    static let tabSwitch = Animation.spring(duration: 0.3, bounce: 0.15)
    static let badgePop = Animation.spring(duration: 0.4, bounce: 0.5)
    static let listInsert = Animation.spring(duration: 0.4, bounce: 0.2)

    // MARK: - Micro-interactions
    static let buttonPress = Animation.spring(duration: 0.2, bounce: 0.3)
    static let iconPop = Animation.spring(duration: 0.4, bounce: 0.5)
    static let shutterClick = Animation.spring(duration: 0.15, bounce: 0.2)
}

// MARK: - Transition Presets

enum TransitionPreset {
    /// Scan result cards slide up
    static let scanResult: AnyTransition = .asymmetric(
        insertion: .move(edge: .bottom).combined(with: .opacity),
        removal: .opacity
    )

    /// Card expand/collapse
    static let cardPresent: AnyTransition = .asymmetric(
        insertion: .scale(scale: 0.9).combined(with: .opacity),
        removal: .scale(scale: 0.95).combined(with: .opacity)
    )

    /// Allergen badge pop
    static let badgePop: AnyTransition = .scale(scale: 0.3).combined(with: .opacity)

    /// Camera mode switch
    static let cameraSwitch: AnyTransition = .opacity

    /// Dish detail expand
    static let dishDetail: AnyTransition = .asymmetric(
        insertion: .scale(scale: 0.85).combined(with: .opacity),
        removal: .scale(scale: 0.95).combined(with: .opacity)
    )
}

// MARK: - Haptic-Coupled Animations

struct HapticSpring {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
                       animation: Animation = AppAnimation.buttonPress,
                       _ body: @escaping () -> Void) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
        withAnimation(animation, body)
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType,
                             animation: Animation = AppAnimation.scanResultReveal,
                             _ body: @escaping () -> Void) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        withAnimation(animation, body)
    }

    /// Shutter-style feedback for scan capture
    static func shutter(_ body: @escaping () -> Void) {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        withAnimation(AppAnimation.shutterClick, body)
    }

    static func selection(animation: Animation = AppAnimation.snappySpring,
                          _ body: @escaping () -> Void) {
        UISelectionFeedbackGenerator().selectionChanged()
        withAnimation(animation, body)
    }
}

// MARK: - View Modifiers

struct BounceOnAppear: ViewModifier {
    @State private var appeared = false
    let delay: Double
    let spring: Animation

    init(delay: Double = 0, spring: Animation = AppAnimation.bouncySpring) {
        self.delay = delay
        self.spring = spring
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(appeared ? 1 : 0.5)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(spring.delay(delay)) {
                    appeared = true
                }
            }
    }
}

struct StaggeredAppear: ViewModifier {
    let index: Int
    let baseDelay: Double
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .offset(y: appeared ? 0 : 20)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(AppAnimation.gentleSpring.delay(baseDelay + Double(index) * 0.06)) {
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
            .opacity(isPressed ? 0.85 : 1)
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
    let delay: Double

    init(delay: Double = 0) { self.delay = delay }

    func body(content: Content) -> some View {
        content
            .offset(y: revealed ? 0 : 20)
            .opacity(revealed ? 1 : 0)
            .onAppear {
                withAnimation(AppAnimation.scanResultReveal.delay(delay)) {
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
    func bounceOnAppear(delay: Double = 0) -> some View {
        modifier(BounceOnAppear(delay: delay))
    }

    func staggeredAppear(index: Int, baseDelay: Double = 0) -> some View {
        modifier(StaggeredAppear(index: index, baseDelay: baseDelay))
    }

    func pressable() -> some View {
        modifier(PressableButton())
    }

    func scanReveal(delay: Double = 0) -> some View {
        modifier(ScanRevealEffect(delay: delay))
    }

    func scannerPulse() -> some View {
        modifier(ScannerPulse())
    }

    func withSpring(_ preset: Animation, value: some Equatable) -> some View {
        animation(preset, value: value)
    }

    func springWithHaptic(_ preset: Animation = AppAnimation.buttonPress, value: some Equatable) -> some View {
        animation(preset, value: value)
            .sensoryFeedback(.impact(flexibility: .rigid), trigger: value)
    }
}
