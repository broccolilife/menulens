// ErrorState.swift — Reusable Error State Views for MenuLens
// Enum-driven layouts with accessibility support

import SwiftUI

// MARK: - App Error Model

enum AppError: LocalizedError, Equatable {
    case network(String)
    case cameraUnavailable
    case ocrFailed(String)
    case translationFailed(String)
    case notFound
    case unauthorized
    case serverError(Int, String)
    case timeout
    case generic(String)

    var errorDescription: String? {
        switch self {
        case .network(let msg): return msg
        case .cameraUnavailable: return "Camera Unavailable"
        case .ocrFailed(let msg): return "Text Recognition Failed: \(msg)"
        case .translationFailed(let msg): return "Translation Failed: \(msg)"
        case .notFound: return "Not Found"
        case .unauthorized: return "Session Expired"
        case .serverError(let code, let msg): return "Server Error (\(code)): \(msg)"
        case .timeout: return "Request Timed Out"
        case .generic(let msg): return msg
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .network: return "Check your internet connection and try again."
        case .cameraUnavailable: return "MenuLens needs camera access to scan menus. Check Settings > Privacy > Camera."
        case .ocrFailed: return "Try holding your device steadier or moving closer to the menu text."
        case .translationFailed: return "Check your internet connection. Translation requires an active connection."
        case .notFound: return "This item may have been moved or deleted."
        case .unauthorized: return "Your session has expired. Please sign in again."
        case .serverError: return "Something went wrong on our end. Please try again in a moment."
        case .timeout: return "The request took too long. Check your connection and try again."
        case .generic: return "Something unexpected happened. Please try again later."
        }
    }

    var systemImage: String {
        switch self {
        case .network: return "wifi.slash"
        case .cameraUnavailable: return "camera.fill"
        case .ocrFailed: return "text.viewfinder"
        case .translationFailed: return "character.book.closed.fill"
        case .notFound: return "magnifyingglass"
        case .unauthorized: return "lock.fill"
        case .serverError: return "server.rack"
        case .timeout: return "clock.badge.exclamationmark"
        case .generic: return "exclamationmark.triangle.fill"
        }
    }

    var isRetryable: Bool {
        switch self {
        case .network, .ocrFailed, .translationFailed, .serverError, .timeout: return true
        case .cameraUnavailable, .notFound, .unauthorized, .generic: return false
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
            if let retryAction, error.isRetryable {
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
                .font(AppTypography.headingSmall)
                .multilineTextAlignment(.center)

            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                    .font(AppTypography.bodySmall)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    @ViewBuilder
    private func retryButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label("Try Again", systemImage: "arrow.clockwise")
                .font(AppTypography.labelLarge)
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .background(DesignTokens.Colors.interactive, in: DesignTokens.Radius.continuous(DesignTokens.Radius.full))
                .foregroundStyle(DesignTokens.Colors.textOnPrimary)
        }
        .accessibilityHint("Retries the failed action")
    }

    private var accessibilityDescription: String {
        var desc = "Error: \(error.localizedDescription)."
        if let suggestion = error.recoverySuggestion {
            desc += " \(suggestion)"
        }
        if retryAction != nil && error.isRetryable {
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
    var actionLabel: String = "Scan a Menu"

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
                .font(AppTypography.bodySmall)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading: \(message)")
    }
}
