// HapticEngine.swift — Haptic feedback for MenuLens
// Pixel+Muse — camera/scan/translation haptics

import SwiftUI
import CoreHaptics

enum HapticEngine {
    static func scanComplete() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func menuItemDetected() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func cameraShutter() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func translationReady() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.6)
    }

    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    // MARK: - CoreHaptics: Scan Success

    static func scanSuccessCelebration() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            let engine = try CHHapticEngine()
            try engine.start()
            let events: [CHHapticEvent] = [
                CHHapticEvent(eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
                    ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.9),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
                    ], relativeTime: 0.08),
            ]
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch { scanComplete() }
    }
}
