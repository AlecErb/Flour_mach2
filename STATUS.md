# Flour Project Status

## Current Phase: Phases 1–11 Complete

**Last Updated:** February 6, 2026

---

## Completed Phases

### Phase 1: Project Setup & Foundation
- [x] Xcode project with SwiftUI
- [x] Flat file organization (CategoryName.swift)
- [x] Info.plist with location permissions
- [x] Constants and config system
- [x] iOS-only target (iPhone + iPad)

### Phase 2: Core Data Models
- [x] User, School, Request, Offer, Transaction, Message models
- [x] Full validation, computed properties, Codable conformance
- [x] Comprehensive MockData with sample data for all models

### Phase 3: Authentication & Onboarding (Mock)
- [x] AppState (@Observable) as central state container
- [x] Welcome screen with demo login option
- [x] .edu email entry with school auto-detection
- [x] Profile setup (display name, phone)
- [x] RootView routing between onboarding and main app

### Phase 4: Location & Maps
- [x] LocationService wrapping CLLocationManager
- [x] Fallback to Stanford campus coordinates
- [x] MapKit view with color-coded request pins
- [x] 4-tab layout (Feed, Map, Activity, Profile)

### Phase 5: Request Creation
- [x] Full request form (description, price, urgency, radius, duration)
- [x] Platform fee preview
- [x] Reusable RequestCard component

### Phase 6: Feed & Activity
- [x] Searchable/filterable feed of nearby requests
- [x] Activity view with my requests + active transactions
- [x] Completed transaction history

### Phase 7: Request Detail & Negotiation
- [x] Dual-role detail view (requester vs fulfiller)
- [x] Make offer / counter-offer flow
- [x] Accept/decline logic
- [x] Negotiation history display

### Phase 8: Chat System
- [x] Message bubbles with timestamps
- [x] Real-time-style message list
- [x] Unread message counts
- [x] Chat list for active conversations

### Phase 9–10: Payment & Completion
- [x] Fee breakdown display (item + 10% fee capped at $2)
- [x] Dual confirmation UI
- [x] Transaction completes when both parties confirm
- [x] Celebration state on completion

### Phase 11: Profile & Settings
- [x] Profile with stats (rating, transaction count)
- [x] Transaction history list
- [x] Settings with notification toggles
- [x] Sign out returns to onboarding

---

## Architecture

- **State:** Single `AppState` (@Observable) injected via `.environment()`
- **Services:** `LocationService` for real CoreLocation; all other services mocked in AppState
- **Navigation:** TabView (Feed, Map, Activity, Profile) + sheet for Create Request
- **Data:** All initialized from `MockData` — no network calls

---

## Next Steps

### Phase 12: Push Notifications
- Configure APNs
- Notify nearby users on new requests

### Phase 13: Backend Development
- Choose backend framework
- Replace mock data with real API calls
- Real authentication (Firebase Auth or custom)
- Real payments (Stripe Connect)
- Real-time chat (WebSocket or Firebase)

### Phase 14: Testing & Polish
- Unit tests for models and AppState
- UI polish, animations, haptics
- Error handling and edge cases

### Phase 15: Pre-Launch
- TestFlight beta
- App Store submission

---

## Known Issues

None — all phases build and run successfully.

---

*This document is updated as development progresses.*
