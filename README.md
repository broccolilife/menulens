# 🔍 MenuLens

An iOS app that scans restaurant menus using OCR, translates dishes, and provides dietary information — perfect for travelers and people with dietary restrictions.

## Features (Planned)
- 📷 Camera-based menu scanning with Vision/VisionKit
- 🌐 Real-time dish translation (30+ languages)
- 🥗 Dietary info & allergen detection
- ⭐ Save favorite dishes and restaurants
- 🗺️ Location-aware restaurant suggestions

## Tech Stack
- SwiftUI + iOS 17+
- VisionKit / Vision framework for OCR
- CoreML for dish classification
- Translation framework
- MapKit + CoreLocation

## Architecture
```
MenuLens/
├── Core/
│   ├── DesignTokens.swift      # Colors, spacing, radii
│   ├── Typography.swift         # Type scale and styles
│   └── SpringAnimations.swift   # Reusable animation presets
├── Features/
│   ├── Scanner/
│   ├── Translation/
│   ├── DietaryInfo/
│   └── Favorites/
└── Shared/
    └── Components/
```
