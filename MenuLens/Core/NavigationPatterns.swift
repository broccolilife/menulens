// NavigationPatterns.swift — Modern Navigation for MenuLens
// Pixel+Flow — NavigationStack + typed routing for deep linking

import SwiftUI

// MARK: - Navigation Destinations

enum MenuLensDestination: Hashable {
    case scanner
    case menuResult(menuId: String)
    case dishDetail(dishId: String)
    case savedMenus
    case settings
}

// MARK: - NavigationStack Router

@Observable
final class AppRouter {
    var path = NavigationPath()

    func navigate(to destination: MenuLensDestination) {
        path.append(destination)
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}

// MARK: - Adaptive Layout

struct AdaptiveStack<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    init(spacing: CGFloat = DesignTokens.Spacing.md, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: spacing, content: content)
            VStack(spacing: spacing, content: content)
        }
    }
}
