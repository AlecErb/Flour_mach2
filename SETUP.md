# Flour Project Setup Guide

## Phase 1: Project Setup & Foundation ✓

This guide will help you complete the Xcode project setup.

### Step 1: Create Xcode Project

Since the file structure has been created, you need to set up the actual Xcode project:

1. **Open Xcode**
2. **Create a new project:**
   - Choose "iOS" → "App"
   - Product Name: `Flour`
   - Team: Your development team
   - Organization Identifier: `com.flour` (or your domain)
   - Bundle Identifier: `com.flour.app`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Minimum Deployments: **iOS 17.0**

3. **Replace generated files with the ones in this repository:**
   - Replace `FlourApp.swift` with the one provided
   - Replace `ContentView.swift` with the one provided
   - Add `Info.plist` to your project

### Step 2: Configure Project Settings

1. **In Xcode, select your project in the navigator**
2. **General tab:**
   - Verify minimum deployment target: **iOS 17.0**
   - Set bundle identifier: `com.flour.app`
   - Choose appropriate team for signing

3. **Signing & Capabilities tab:**
   - Add capability: **Push Notifications**
   - Add capability: **Background Modes**
     - Enable: Remote notifications
     - Enable: Location updates (for background location)
   - Add capability: **Maps**

### Step 3: Add Swift Package Dependencies

1. **In Xcode:** File → Add Package Dependencies...

2. **Add Firebase iOS SDK:**
   - URL: `https://github.com/firebase/firebase-ios-sdk.git`
   - Version: 10.20.0 or later
   - Select these products:
     - FirebaseAuth
     - FirebaseFirestore
     - FirebaseDatabase
     - FirebaseMessaging

3. **Add Stripe iOS SDK:**
   - URL: `https://github.com/stripe/stripe-ios.git`
   - Version: 23.27.0 or later
   - Select: StripePaymentSheet

### Step 4: Organize Files in Xcode

Create groups (folders) in Xcode to match the structure:

```
Flour/
├── App/
│   ├── FlourApp.swift
│   └── ContentView.swift
├── Models/
│   └── Models.swift (placeholder)
├── Views/
│   └── Views.swift (placeholder)
├── ViewModels/
│   └── ViewModels.swift (placeholder)
├── Services/
│   └── Services.swift (placeholder)
├── Utilities/
│   ├── Utilities.swift (placeholder)
│   └── Constants.swift
├── Resources/
│   ├── Assets.xcassets
│   ├── Config.example.swift
│   └── Assets.swift (placeholder)
└── Info.plist
```

### Step 5: Set Up Configuration

1. **Copy Config.example.swift to Config.swift:**
   ```bash
   cp Resources/Config.example.swift Resources/Config.swift
   ```

2. **Add Config.swift to your project in Xcode**
   - Make sure it's added to your target
   - Verify it's listed in `.gitignore`

### Step 6: Firebase Setup

1. **Go to [Firebase Console](https://console.firebase.google.com/)**
2. **Create a new project** (or use existing)
3. **Add an iOS app:**
   - Bundle ID: `com.flour.app`
   - Download `GoogleService-Info.plist`
4. **Add `GoogleService-Info.plist` to your Xcode project:**
   - Drag into project navigator
   - Make sure "Copy items if needed" is checked
   - Add to your target

5. **Enable Firebase services:**
   - **Authentication:** Enable Email/Password and Phone providers
   - **Firestore Database:** Create database in test mode (for now)
   - **Realtime Database:** Create database (for chat)
   - **Cloud Messaging:** Set up for push notifications

### Step 7: Stripe Setup

1. **Go to [Stripe Dashboard](https://dashboard.stripe.com/)**
2. **Create account** or sign in
3. **Get your test API keys:**
   - Developers → API keys
   - Copy "Publishable key" (starts with `pk_test_`)
4. **Update Config.swift:**
   ```swift
   static var publishableKey: String {
       return "pk_test_YOUR_ACTUAL_KEY_HERE"
   }
   ```

### Step 8: Initialize Firebase in App

Update `FlourApp.swift` to initialize Firebase:

```swift
import SwiftUI
import FirebaseCore

@main
struct FlourApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Step 9: Build and Run

1. **Select a simulator** (iPhone 15 Pro recommended)
2. **Press Cmd+B** to build
3. **Press Cmd+R** to run
4. **Verify the app launches** with "Flour" text visible

### Step 10: Version Control

1. **Initialize git** (if not already):
   ```bash
   git init
   git add .
   git commit -m "Phase 1: Project setup and foundation"
   ```

2. **Create a remote repository** (GitHub, GitLab, etc.)
3. **Push your code:**
   ```bash
   git remote add origin YOUR_REPO_URL
   git push -u origin main
   ```

---

## Phase 1 Checklist

- [ ] Xcode project created with iOS 17.0 minimum deployment
- [ ] Bundle identifier configured: `com.flour.app`
- [ ] Folder structure organized in Xcode
- [ ] Firebase SDK added via Swift Package Manager
- [ ] Stripe SDK added via Swift Package Manager
- [ ] Info.plist configured with required privacy descriptions
- [ ] Push Notifications capability enabled
- [ ] Background Modes capability enabled
- [ ] Maps capability enabled
- [ ] `.gitignore` configured to exclude secrets
- [ ] Config.swift created from template (not committed)
- [ ] Firebase project created and `GoogleService-Info.plist` added
- [ ] Stripe account created and test keys configured
- [ ] App builds and runs successfully
- [ ] Git repository initialized and initial commit made

---

## Next Steps

Once Phase 1 is complete, proceed to **Phase 2: Core Data Models** where you'll define the data structures for User, Request, Offer, Transaction, Message, and School.

## Troubleshooting

### Build Errors
- Ensure all package dependencies are resolved (File → Packages → Resolve Package Versions)
- Clean build folder: Cmd+Shift+K
- Clean derived data: Xcode → Settings → Locations → Derived Data → Delete

### Firebase Not Working
- Verify `GoogleService-Info.plist` is added to target
- Check that `FirebaseApp.configure()` is called in app init
- Ensure Firebase project matches bundle identifier

### Location Permissions
- Make sure Info.plist has location usage descriptions
- Test on a real device for best results
- Simulator: Features → Location → Custom Location

---

*Last updated: 2026-02-06*
