// AnimationChoreography.swift — Coordinated multi-element animation sequences
// Pixel+Muse — orchestrated motion for menu scanning UX

import SwiftUI

// MARK: - Staggered Menu Items

struct StaggeredMenuItems<Content: View>: View {
    let count: Int
    let baseDelay: Double
    let spring: Animation
    @ViewBuilder let content: (Int) -> Content

    @State private var appeared = false

    init(
        count: Int,
        baseDelay: Double = 0.05,
        spring: Animation = .spring(response: 0.35, dampingFraction: 0.75),
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.count = count
        self.baseDelay = baseDelay
        self.spring = spring
        self.content = content
    }

    var body: some View {
        ForEach(0..<count, id: \.self) { index in
            content(index)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)
                .animation(spring.delay(Double(index) * baseDelay), value: appeared)
        }
        .onAppear { appeared = true }
    }
}

// MARK: - Scan Complete Choreography

struct ScanCompleteBanner: View {
    let itemCount: Int
    @State private var phase = 0

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.green.gradient)
                .scaleEffect(phase >= 1 ? 1 : 0.3)
                .opacity(phase >= 1 ? 1 : 0)

            Text("\(itemCount) items recognized")
                .font(.headline)
                .opacity(phase >= 2 ? 1 : 0)
                .offset(y: phase >= 2 ? 0 : 10)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: phase)
        .onAppear {
            withAnimation { phase = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation { phase = 2 }
            }
        }
    }
}

// MARK: - Camera Focus Ring

struct CameraFocusRing: View {
    let isScanning: Bool
    @State private var rotation: Double = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(
                AngularGradient(
                    colors: [.green.opacity(0.8), .green.opacity(0.2), .green.opacity(0.8)],
                    center: .center
                ),
                lineWidth: 2.5
            )
            .rotationEffect(.degrees(rotation))
            .opacity(isScanning ? 1 : 0)
            .animation(.spring(response: 0.3), value: isScanning)
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}
