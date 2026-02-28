// ErrorState.swift — Reusable Error State Views for MenuLens
// Applied from Pixel+Flow knowledge: enum-driven layouts, view decomposition, accessibility

import SwiftUI

// MARK: - App Error Model

enum AppError: LocalizedError, Equatable {
    case network(String)
    case cameraUnavailable
    case ocrFailed
    case translationFailed(String)
    case notFound
    case unauthorized
    case generic(String)

    var errorDescription: String? {
        switch self {
        case .network(let msg): return msg
        case .cameraUnavailable: return "Camera Unavailable"
        case .ocrFailed: return "Could Not Read Menu"
        case .translationFailed(let lang): return "Translation to \(lang) Failed"
        case .notFound: return "Not Found"
        case .unauthorized: return "Unauthorized"
        case .generic(let msg): return msg
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .network: return "Check your connection and try again."
        case .cameraUnavailable: return "Please allow camera access in Settings."
        case .ocrFailed: return "Try holding the camera steadier or moving closer to the menu."
        case .translationFailed: return "Check your connection. Some languages require a download."
        case .notFound: return "The item may have been removed."
        case .unauthorized: return "Please sign in again."
        case .generic: return "Please try again later."
        }
    }

    var systemImage: String {
        switch self {
        case .network: return "wifi.slash"
        case .cameraUnavailable: return "camera.fill"
        case .ocrFailed: return "doc.text.magnifyingglass"
        case .translationFailed: return "character.book.closed.fill"
        case .notFound: return "magnifyingglass"
        case .unauthorized: return "lock.fill"
        case .generic: return "exclamationmark.triangle.fill"
        }
    }
}

// MARK: - Error State View

struct ErrorStateView: View {
    let error: AppError
    var retryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            errorIcon
            errorText
            if let retryAction {
                retryButton(action: retryAction)
            }
        }
        .padding(DesignTokens.Spacing.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    @ViewBuilder
    private var errorIcon: some View {
        Image(systemName: error.systemImage)
            .font(.system(size: 48))
            .foregroundStyle(.secondary)
            .symbolEffect(.pulse)
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private var errorText: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Text(error.localizedDescription)
                .font(.headline)
                .multilineTextAlignment(.center)

            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    @ViewBuilder
    private func retryButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label("Try Again", systemImage: "arrow.clockwise")
                .font(.body.bold())
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .background(.tint, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.full))
                .foregroundStyle(.white)
        }
        .accessibilityHint("Retries the failed action")
    }

    private var accessibilityDescription: String {
        var desc = "Error: \(error.localizedDescription)."
        if let suggestion = error.recoverySuggestion {
            desc += " \(suggestion)"
        }
        if retryAction != nil {
            desc += " Retry button available."
        }
        return desc
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String
    var action: (() -> Void)?
    var actionLabel: String = "Get Started"

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            Text(message)
        } actions: {
            if let action {
                Button(actionLabel, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Loading State

struct LoadingStateView: View {
    let message: String

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            ProgressView()
                .scaleEffect(1.2)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading: \(message)")
    }
}
