# Xcode Project Configuration Reference

This document provides the exact settings needed when creating the Xcode project.

## Project Creation Settings

**Template:** iOS → App

| Setting | Value |
|---------|-------|
| Product Name | `Flour` |
| Team | Your development team |
| Organization Identifier | `com.flour` |
| Bundle Identifier | `com.flour.app` |
| Interface | SwiftUI |
| Language | Swift |
| Storage | None |
| Include Tests | Yes |

## Build Settings

### Deployment Info
- **iOS Deployment Target:** 17.0
- **Supported Destinations:** iPhone, iPad
- **Supported Orientations (iPhone):** Portrait
- **Supported Orientations (iPad):** All
- **Status Bar Style:** Dark Content

### Signing & Capabilities

#### Required Capabilities:

1. **Push Notifications**
   - No additional configuration needed

2. **Background Modes**
   - [x] Remote notifications
   - [x] Location updates

3. **Maps**
   - No additional configuration needed

## Swift Package Dependencies

Add these packages via File → Add Package Dependencies:

### Firebase iOS SDK
```
Repository URL: https://github.com/firebase/firebase-ios-sdk.git
Version: 10.20.0 (Up to Next Major)
```

**Products to Add:**
- FirebaseAuth
- FirebaseFirestore
- FirebaseDatabase
- FirebaseMessaging

### Stripe iOS SDK
```
Repository URL: https://github.com/stripe/stripe-ios.git
Version: 23.27.0 (Up to Next Major)
```

**Products to Add:**
- StripePaymentSheet

## File Organization in Xcode

Create these groups (yellow folders) in your project navigator:

```
Flour
├── 📁 App
│   ├── FlourApp.swift
│   └── ContentView.swift
├── 📁 Models
│   └── Models.swift
├── 📁 Views
│   └── Views.swift
├── 📁 ViewModels
│   └── ViewModels.swift
├── 📁 Services
│   └── Services.swift
├── 📁 Utilities
│   ├── Constants.swift
│   └── Utilities.swift
├── 📁 Resources
│   ├── Assets.xcassets
│   ├── Config.example.swift
│   ├── Config.swift (not in git)
│   └── Assets.swift
├── Info.plist
└── 📁 FlourTests
    └── FlourTests.swift
```

## Build Phases

### Link Binary With Libraries
Should automatically include:
- SwiftUI.framework
- MapKit.framework
- CoreLocation.framework
- UserNotifications.framework
- All Firebase frameworks
- Stripe framework

### Copy Bundle Resources
Ensure these are included:
- Assets.xcassets
- GoogleService-Info.plist
- Info.plist

## Scheme Configuration

### Run Scheme
- **Build Configuration:** Debug
- **Location:** Allow Location Simulation → Custom Location

### Test Scheme
- **Build Configuration:** Debug
- **Language:** System Language
- **Region:** System Region

## Build Configurations

### Debug
- **Swift Optimization Level:** No Optimization (-Onone)
- **Swift Compilation Mode:** Incremental
- **Active Compilation Conditions:** DEBUG

### Release
- **Swift Optimization Level:** Optimize for Speed (-O)
- **Swift Compilation Mode:** Whole Module
- **Active Compilation Conditions:** (empty)

## App Transport Security

Configured in Info.plist:
- Allow localhost connections for local development
- All other connections require HTTPS

## Privacy Permissions (Info.plist)

Already configured in the Info.plist file:
- Location When In Use
- Location Always and When In Use
- Camera Usage
- Photo Library Usage

## Simulator Setup

Recommended simulators for testing:
- iPhone 15 Pro (iOS 17.0+)
- iPhone 15 (iOS 17.0+)
- iPad Pro 12.9-inch (6th generation)

### Simulator Location Settings
Features → Location → Custom Location:
- **Latitude:** 40.7128 (Example: New York)
- **Longitude:** -74.0060
- Or use "City Run" for moving simulation

## Firebase Configuration Checklist

In Firebase Console (console.firebase.google.com):

1. **Create Project** named "Flour"
2. **Add iOS app:**
   - iOS bundle ID: `com.flour.app`
   - App nickname: Flour iOS
   - Download GoogleService-Info.plist
3. **Authentication:**
   - Enable Email/Password
   - Enable Phone authentication
4. **Firestore Database:**
   - Create database (Start in test mode)
   - Location: Choose nearest region
5. **Realtime Database:**
   - Create database (Start in test mode)
   - Location: Choose nearest region
6. **Cloud Messaging:**
   - Upload APNs certificate or key (for push notifications)
   - Can be done later in development

## Stripe Configuration Checklist

In Stripe Dashboard (dashboard.stripe.com):

1. **Create account** or sign in
2. **Switch to Test Mode** (toggle in top right)
3. **Navigate to:** Developers → API keys
4. **Copy:** Publishable key (pk_test_...)
5. **Paste into:** Config.swift
6. **Later:** Set up Connect platform for marketplace payments

## Verification Steps

After setup, verify:
1. ✓ Project builds without errors (Cmd+B)
2. ✓ Project runs on simulator (Cmd+R)
3. ✓ No package dependency errors
4. ✓ Firebase configured (check Xcode console for Firebase logs)
5. ✓ Location permissions can be requested
6. ✓ Git repository initialized
7. ✓ Config.swift not tracked in git
8. ✓ GoogleService-Info.plist not tracked in git (if added to .gitignore)

---

*Use this document as a reference when setting up the Xcode project.*
