// StructuredLogging.swift — OSLog structured categories for MenuLens
// Pixel+Flow — agent-debuggable logging

import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.broccolilife.menulens"

    /// Camera and scanner events
    static let scanner = Logger(subsystem: subsystem, category: "Scanner")
    /// OCR text recognition
    static let ocr = Logger(subsystem: subsystem, category: "OCR")
    /// Translation service
    static let translation = Logger(subsystem: subsystem, category: "Translation")
    /// UI state transitions and navigation
    static let ui = Logger(subsystem: subsystem, category: "UI")
    /// Persistence: saved menus, favorites
    static let persistence = Logger(subsystem: subsystem, category: "Persistence")
    /// Network requests
    static let network = Logger(subsystem: subsystem, category: "Network")
}
