// Onboarding.swift — TipKit-based contextual onboarding for MenuLens
// Pixel+Flow — contextual tips, not front-loaded tutorials

import SwiftUI
import TipKit

// MARK: - Scanner Tips

struct ScanMenuTip: Tip {
    var title: Text { Text("Scan a Menu") }
    var message: Text? { Text("Point your camera at a menu to automatically detect and translate dish names.") }
    var image: Image? { Image(systemName: "camera.viewfinder") }
}

struct AllergenFilterTip: Tip {
    @Parameter static var scannedMenuCount: Int = 0

    var title: Text { Text("Filter Allergens") }
    var message: Text? { Text("Set your dietary preferences to highlight safe dishes and flag allergens.") }
    var image: Image? { Image(systemName: "allergens.fill") }

    var rules: [Rule] {
        #Rule(Self.$scannedMenuCount) { $0 >= 2 }
    }
}

struct SaveMenuTip: Tip {
    var title: Text { Text("Save for Later") }
    var message: Text? { Text("Tap the bookmark icon to save a translated menu for offline access.") }
    var image: Image? { Image(systemName: "bookmark.fill") }
}

// MARK: - Tip Configuration

enum OnboardingManager {
    static func configure() {
        try? Tips.configure([
            .displayFrequency(.weekly),
            .datastoreLocation(.applicationDefault)
        ])
    }
}
