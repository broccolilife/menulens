// ObservableState.swift — @Observable macro patterns for MenuLens
// Pixel+Muse — fine-grained reactivity, iOS 17+

import SwiftUI
import Observation

// MARK: - Scan State

@Observable
final class ScanState {
    var isScanning: Bool = false
    var recognizedItems: [MenuItem] = []
    var scanProgress: Double = 0
    var errorMessage: String?

    var hasResults: Bool { !recognizedItems.isEmpty }
    var itemCount: Int { recognizedItems.count }

    func reset() {
        isScanning = false
        recognizedItems.removeAll()
        scanProgress = 0
        errorMessage = nil
    }
}

// MARK: - Menu Item Model

struct MenuItem: Identifiable, Hashable {
    let id: String
    let name: String
    let price: String?
    let description: String?
    let allergens: [String]
}

// MARK: - User Preferences

@Observable
final class MenuLensSettings {
    var showAllergens: Bool = true
    var preferredLanguage: String = "en"
    var hapticFeedback: Bool = true
    var autoTranslate: Bool = false
}

// MARK: - Environment Registration

extension EnvironmentValues {
    @Entry var scanState: ScanState = ScanState()
    @Entry var menuLensSettings: MenuLensSettings = MenuLensSettings()
}

// MARK: - Usage Patterns

/*
 // Root injection (App.swift):
 @State private var scanState = ScanState()

 var body: some Scene {
     WindowGroup {
         ContentView()
             .environment(\.scanState, scanState)
     }
 }

 // Consuming view:
 struct ScanResultsView: View {
     @Environment(\.scanState) private var scan

     var body: some View {
         List(scan.recognizedItems) { item in
             Text(item.name)
         }
     }
 }
*/
