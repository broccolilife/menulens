import SwiftUI

// MARK: - Spring Animation Presets for MenuLens

enum SpringPreset {
    case snappy, bouncy, gentle, scanPulse, cardReveal, shutter

    var animation: Animation {
        switch self {
        case .snappy:     return .spring(response: 0.2, dampingFraction: 0.7)
        case .bouncy:     return .bouncy(duration: 0.5, extraBounce: 0.25)
        case .gentle:     return .spring(response: 0.55, dampingFraction: 0.9)
        case .scanPulse:  return .spring(response: 0.3, dampingFraction: 0.5)
        case .cardReveal: return .spring(response: 0.45, dampingFraction: 0.8)
        case .shutter:    return .spring(response: 0.12, dampingFraction: 0.65)
        }
    }
}

// MARK: - Scanner-Specific Modifiers

extension View {
    /// Generic spring scale.
    func springScale(isActive: Bool, preset: SpringPreset = .bouncy, activeScale: CGFloat = 1.1) -> some View {
        self
            .scaleEffect(isActive ? activeScale : 1.0)
            .animation(preset.animation, value: isActive)
    }

    /// Scanner viewfinder pulse — breathing glow when scanning.
    func scannerPulse(isScanning: Bool) -> some View {
        self
            .scaleEffect(isScanning ? 1.02 : 1.0)
            .opacity(isScanning ? 1.0 : 0.85)
            .animation(
                isScanning
                    ? .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
                    : .default,
                value: isScanning
            )
    }

    /// OCR result highlight — flash when text is recognized.
    func ocrHighlight(trigger: Bool) -> some View {
        self
            .background(
                trigger
                    ? DesignTokens.Colors.scannerHighlight.opacity(0.15)
                    : Color.clear
            )
            .animation(SpringPreset.scanPulse.animation, value: trigger)
    }

    /// Dish card cascade entrance — staggered slide-up.
    func cardCascade(isVisible: Bool, index: Int) -> some View {
        self
            .offset(y: isVisible ? 0 : 40)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(
                SpringPreset.cardReveal.animation.delay(Double(index) * 0.08),
                value: isVisible
            )
    }

    /// Shutter snap feedback — brief scale dip.
    func shutterSnap(trigger: Bool) -> some View {
        self
            .scaleEffect(trigger ? 0.95 : 1.0)
            .animation(SpringPreset.shutter.animation, value: trigger)
    }

    /// Allergen warning shake.
    func allergenShake(trigger: Bool) -> some View {
        self
            .offset(x: trigger ? 5 : 0)
            .animation(
                trigger
                    ? .spring(response: 0.1, dampingFraction: 0.3).repeatCount(3)
                    : .default,
                value: trigger
            )
    }

    /// Nutrition panel expand/collapse.
    func nutritionReveal(isExpanded: Bool) -> some View {
        self
            .scaleEffect(y: isExpanded ? 1.0 : 0.0, anchor: .top)
            .opacity(isExpanded ? 1.0 : 0.0)
            .animation(SpringPreset.gentle.animation, value: isExpanded)
    }
}

// MARK: - Transitions

extension AnyTransition {
    static var springPopIn: AnyTransition {
        .scale(scale: 0.5)
        .combined(with: .opacity)
    }

    static var slideUpSpring: AnyTransition {
        .move(edge: .bottom)
        .combined(with: .opacity)
    }

    static var scanReveal: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.9, anchor: .center).combined(with: .opacity),
            removal: .opacity
        )
    }
}
