// MenuScanOverlay.swift — Camera scan overlay with animated guide frame
// Pixel (Eva) — 2026-03-23

import SwiftUI

/// Overlay shown during menu scanning with animated corner brackets
struct MenuScanOverlay: View {
    @State private var isScanning = false
    @State private var scanPulse = false
    let onCapture: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Camera feed would go behind this
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack(spacing: DesignTokens.Spacing.lg) {
                instructionBanner
                Spacer()
                scanFrame
                Spacer()
                captureButton
            }
            .padding(DesignTokens.Spacing.lg)
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var instructionBanner: some View {
        Text(isScanning ? "Analyzing menu…" : "Point at a menu to scan")
            .font(AppTypography.callout)
            .foregroundStyle(.white)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(.black.opacity(0.6), in: Capsule())
            .animation(.easeInOut, value: isScanning)
    }
    
    @ViewBuilder
    private var scanFrame: some View {
        ZStack {
            // Corner brackets
            ScanCorners()
                .stroke(.white, lineWidth: 3)
                .frame(width: 280, height: 380)
                .opacity(scanPulse ? 0.6 : 1.0)
                .animation(
                    .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                    value: scanPulse
                )
            
            if isScanning {
                // Scanning line
                Rectangle()
                    .fill(LinearGradient(
                        colors: [.clear, .green.opacity(0.5), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: 260, height: 2)
                    .offset(y: scanPulse ? 180 : -180)
                    .animation(
                        .linear(duration: 2.0).repeatForever(autoreverses: true),
                        value: scanPulse
                    )
            }
        }
        .onAppear { scanPulse = true }
    }
    
    @ViewBuilder
    private var captureButton: some View {
        HStack(spacing: DesignTokens.Spacing.xl) {
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Button {
                withAnimation(SpringPreset.snappy) {
                    isScanning = true
                }
                onCapture()
            } label: {
                ZStack {
                    Circle()
                        .stroke(.white, lineWidth: 4)
                        .frame(width: 72, height: 72)
                    Circle()
                        .fill(.white)
                        .frame(width: 60, height: 60)
                        .scaleEffect(isScanning ? 0.85 : 1.0)
                        .animation(SpringPreset.bouncy, value: isScanning)
                }
            }
            
            // Placeholder for symmetry
            Color.clear.frame(width: 40, height: 40)
        }
    }
}

// MARK: - Scan Corner Brackets Shape

struct ScanCorners: Shape {
    func path(in rect: CGRect) -> Path {
        let len: CGFloat = 30
        var p = Path()
        
        // Top-left
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + len))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX + len, y: rect.minY))
        
        // Top-right
        p.move(to: CGPoint(x: rect.maxX - len, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + len))
        
        // Bottom-right
        p.move(to: CGPoint(x: rect.maxX, y: rect.maxY - len))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX - len, y: rect.maxY))
        
        // Bottom-left
        p.move(to: CGPoint(x: rect.minX + len, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - len))
        
        return p
    }
}

#Preview {
    MenuScanOverlay(onCapture: {}, onDismiss: {})
}
