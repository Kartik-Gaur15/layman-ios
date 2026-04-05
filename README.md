# Layman — Business, Tech & Startups Made Simple

A simplified news reader iOS app built with SwiftUI.

## Screens
- Welcome Screen with swipe to start
- Auth Screen (Login/Signup)
- Home with Featured Carousel and Today's Picks
- Article Detail with 3 swipeable content cards
- Ask Layman AI Chatbot (Gemini API)
- Saved Articles
- Profile

## Setup
1. Clone the repo
2. Create `Layman/Config.swift`:
```swift
enum Config {
    static let supabaseURL = "YOUR_URL"
    static let supabaseAnonKey = "YOUR_KEY"
    static let newsAPIKey = "YOUR_NEWSDATA_KEY"
    static let geminiAPIKey = "YOUR_GEMINI_KEY"
}
```
3. Open `Layman.xcodeproj` in Xcode
4. Run on simulator or device

## Tech Stack
- SwiftUI
- Supabase (Auth + Database)
- NewsData.io API
- Google Gemini AI API
- MVVM Architecture

## AI Tool Used
Claude (claude.ai) — used for architecture planning, code generation, and debugging
