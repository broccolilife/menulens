// ContextualOnboarding.swift — Contextual tips for MenuLens
// Pixel+Muse — teach in context, not through tutorials

import SwiftUI

// MARK: - Tip Model

struct ContextualTip: Identifiable {
    let id: String
    let message: String
    let icon: String
    let anchor: TipAnchor

    enum TipAnchor { case above, below, leading, trailing }
}

// MARK: - Tip Store

@Observable
final class TipStore {
    private var seenTips: Set<String> = []
    private let storageKey = "menulens_seen_tips"

    init() {
        seenTips = Set(UserDefaults.standard.stringArray(forKey: storageKey) ?? [])
    }

    func shouldShow(_ tipID: String) -> Bool { !seenTips.contains(tipID) }

    func markSeen(_ tipID: String) {
        seenTips.insert(tipID)
        UserDefaults.standard.set(Array(seenTips), forKey: storageKey)
    }
}

// MARK: - MenuLens Tips

extension ContextualTip {
    static let pointCamera = ContextualTip(
        id: "point_camera", message: "Point your camera at a menu to scan it.",
        icon: "camera.viewfinder", anchor: .below
    )
    static let tapToTranslate = ContextualTip(
        id: "tap_translate", message: "Tap any item to see its translation and allergen info.",
        icon: "character.book.closed", anchor: .above
    )
    static let allergenAlert = ContextualTip(
        id: "allergen_alert", message: "Items with your flagged allergens are highlighted in red.",
        icon: "exclamationmark.triangle", anchor: .above
    )
}

// MARK: - Tip Bubble View

struct TipBubble: View {
    let tip: ContextualTip
    let onDismiss: () -> Void
    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: tip.icon)
                .font(.title3).foregroundStyle(.white)
            Text(tip.message)
                .font(.subheadline).foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .background(.ultraThinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        .scaleEffect(isVisible ? 1 : 0.8)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { isVisible = true }
        }
    }
}

// MARK: - Modifier

struct ContextualTipModifier: ViewModifier {
    let tip: ContextualTip
    @Bindable var store: TipStore
    @State private var showing = false

    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment(for: tip.anchor)) {
                if showing && store.shouldShow(tip.id) {
                    TipBubble(tip: tip) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { showing = false }
                        store.markSeen(tip.id)
                    }
                    .padding(8)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .onAppear {
                if store.shouldShow(tip.id) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation { showing = true }
                    }
                }
            }
    }

    private func alignment(for anchor: ContextualTip.TipAnchor) -> Alignment {
        switch anchor {
        case .above: .top; case .below: .bottom
        case .leading: .leading; case .trailing: .trailing
        }
    }
}

extension View {
    func contextualTip(_ tip: ContextualTip, store: TipStore) -> some View {
        modifier(ContextualTipModifier(tip: tip, store: store))
    }
}
