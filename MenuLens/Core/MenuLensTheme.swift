// MenuLensTheme.swift — App-specific theme for MenuLens
// From Pixel knowledge: app-specific tokens extend shared DesignTokens

import SwiftUI

enum MenuLensTheme {
    // Scanner overlay styles
    static let viewfinderCornerLength: CGFloat = 24
    static let viewfinderLineWidth: CGFloat = 3
    static let captureButtonSize: CGFloat = 72
    static let captureButtonInnerSize: CGFloat = 60

    // Result card styles
    static let resultCardMaxHeight: CGFloat = 400
    static let menuItemMinHeight: CGFloat = 56

    // Animation durations
    static let scanDuration: Double = 0.8
    static let resultRevealDuration: Double = 0.35
    static let dismissDuration: Double = 0.25
}

// MARK: - Menu-specific Error States

enum MenuLensError: LocalizedError, Equatable {
    case cameraPermissionDenied
    case poorLighting
    case menuNotDetected
    case translationUnavailable(String)
    case allergenDatabaseOffline

    var errorDescription: String? {
        switch self {
        case .cameraPermissionDenied: return "Camera Access Required"
        case .poorLighting: return "Poor Lighting Detected"
        case .menuNotDetected: return "No Menu Found"
        case .translationUnavailable(let lang): return "\(lang) Translation Unavailable"
        case .allergenDatabaseOffline: return "Allergen Database Offline"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .cameraPermissionDenied: return "Go to Settings → MenuLens → Camera to enable access."
        case .poorLighting: return "Move to a better-lit area or turn on your flashlight."
        case .menuNotDetected: return "Point the camera at a menu and hold steady."
        case .translationUnavailable: return "Download the language pack in Settings."
        case .allergenDatabaseOffline: return "Connect to the internet to update allergen data."
        }
    }

    var systemImage: String {
        switch self {
        case .cameraPermissionDenied: return "camera.fill"
        case .poorLighting: return "lightbulb.slash"
        case .menuNotDetected: return "doc.text.magnifyingglass"
        case .translationUnavailable: return "character.book.closed.fill"
        case .allergenDatabaseOffline: return "externaldrive.badge.wifi"
        }
    }
}
