// Accessibility.swift — Accessibility Utilities & View Modifiers for MenuLens
// Every interactive element needs accessibilityLabel, Dynamic Type support

import SwiftUI

// MARK: - Accessibility Helpers

extension View {
    /// Semantic card grouping with accessibility
    func accessibleCard(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }

    /// Annotation modifier — adds descriptive caption below content
    func annotation(_ text: String) -> some View {
        modifier(AnnotationModifier(text: text))
    }
}

// MARK: - Annotation Modifier

struct AnnotationModifier: ViewModifier {
    let text: String

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            content
            Text(text)
                .font(AppTypography.labelSmall)
                .foregroundStyle(.secondary)
                .accessibilityLabel(text)
        }
    }
}

// MARK: - Reusable Section

struct AppSection<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            if let title {
                Text(title)
                    .font(AppTypography.headingSmall)
                    .foregroundStyle(.secondary)
                    .accessibilityAddTraits(.isHeader)
            }
            content()
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial, in: DesignTokens.Radius.continuous(DesignTokens.Radius.md))
    }
}

// MARK: - Error Mapping Utility

extension AppError {
    /// Map a URLError to a user-friendly AppError
    static func from(_ urlError: URLError) -> AppError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .network("You appear to be offline. Menu translation requires an internet connection.")
        case .timedOut:
            return .timeout
        case .userAuthenticationRequired:
            return .unauthorized
        default:
            return .network("A network error occurred: \(urlError.localizedDescription)")
        }
    }

    /// Map an HTTP status code to AppError
    static func fromHTTPStatus(_ code: Int, message: String = "") -> AppError {
        switch code {
        case 401: return .unauthorized
        case 404: return .notFound
        case 408, 504: return .timeout
        case 500...599: return .serverError(code, message.isEmpty ? "Internal server error" : message)
        default: return .generic("Unexpected response (\(code))")
        }
    }
}
