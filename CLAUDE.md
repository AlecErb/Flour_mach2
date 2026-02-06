# Flour - AI Assistant Context

## Project Overview

**Flour** is a hyperlocal, real-time marketplace iOS app for immediate needs, targeting college campuses (initially Greek life communities). Users can request items from nearby people, offer prices, and complete exchanges in person within a ~10 minute walk radius.

**Tech Stack:**
- **Platform:** iOS only (SwiftUI, iOS 17+)
- **IDE:** Xcode 26.2 beta
- **State:** `@Observable` with environment injection (`AppState`)
- **Maps:** MapKit + CoreLocation
- **Backend:** Mock (in-memory via `AppState`) — no network calls yet
- **Future:** Firebase Auth, Stripe Connect, APNs, real backend TBD

**Build Settings:**
- `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` (Swift 6 strict concurrency)
- `SUPPORTED_PLATFORMS = "iphoneos iphonesimulator"` (iOS only)
- `TARGETED_DEVICE_FAMILY = "1,2"` (iPhone + iPad)
- Manual `Info.plist` with `GENERATE_INFOPLIST_FILE = NO`
- xcode-select points to CommandLineTools; use `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer` for CLI builds

**File Organization:** Flat naming convention — all Swift files at project root:
- `ViewsFeedView.swift`, `ServicesAppState.swift`, `ModelsUser.swift`, etc.
- No subdirectories; PBX references are manual entries in `project.pbxproj`

## Key Concepts

### User Flow Summary
1. **Requester** posts item need with price → nearby users notified
2. **Fulfiller** can accept/counter/ignore
3. Back-and-forth negotiation until accepted or declined
4. On match → names revealed, chat unlocks
5. Meet, exchange, both confirm completion
6. Payment auto-transfers (buyer pays item price + platform fee)

### Privacy & Identity
- Anonymous until match (no identifying info in requests)
- Display name only revealed after acceptance
- No house affiliation shown
- In-app chat only (no phone numbers shared)

### Payments
- **Buyer** pays: Item price + platform fee (10% capped at $2)
- **Seller** receives: Full agreed price (no fees deducted)
- Stripe escrow until both parties confirm completion
- Examples:
  - $5 item → $0.50 fee → Buyer pays $5.50
  - $30 item → $2.00 fee → Buyer pays $32

### Authentication
- .edu email verification required
- Phone number (SMS) verification required
- School selection during onboarding

### Request Lifecycle
- Requests expire after configurable duration (default: 2 hours)
- Status flow: open → negotiating → matched → completed/cancelled/expired

## Architecture

- **State:** Single `AppState` (@Observable) injected via `.environment()`
- **Services:** `LocationService` for real CoreLocation; all other services mocked in AppState
- **Navigation:** TabView (Feed, Map, Activity, Profile) + sheet for Create Request
- **Data:** All initialized from `MockData` — no network calls

## Project Structure

```
Flour_mach2/
├── FlourApp.swift                          # App entry point
├── ServicesAppState.swift                  # Central @Observable state container
├── ServicesLocationService.swift           # CoreLocation wrapper
├── ViewsRootView.swift                    # Routes onboarding vs main app
├── ViewsOnboardingWelcomeView.swift       # Welcome screen
├── ViewsOnboardingEmailView.swift         # .edu email entry
├── ViewsOnboardingProfileSetupView.swift  # Profile creation
├── ViewsMainTabView.swift                 # 4-tab layout + create button
├── ViewsFeedView.swift                    # Nearby requests list
├── ViewsMapView.swift                     # MapKit with request pins
├── ViewsActivityView.swift                # My requests + transactions
├── ViewsCreateRequestView.swift           # New request form
├── ViewsRequestDetailView.swift           # Request info + actions
├── ViewsOfferSheet.swift                  # Make/counter offer
├── ViewsNegotiationHistoryView.swift      # Offer chain display
├── ViewsChatView.swift                    # Message bubbles + input
├── ViewsChatListView.swift                # Active conversations
├── ViewsCompletionView.swift              # Dual confirmation
├── ViewsProfileView.swift                 # User info + stats
├── ViewsSettingsView.swift                # Notification/payment toggles
├── ViewsTransactionHistoryView.swift      # Past transactions
├── SharedRequestCard.swift                # Reusable request card
├── SharedFeeBreakdownView.swift           # Price/fee/total display
├── ModelsUser.swift                       # User model
├── ModelsSchool.swift                     # School model
├── ModelsRequest.swift                    # Request + Urgency + Location
├── ModelsOffer.swift                      # Offer + counter-offer
├── ModelsTransaction.swift                # Transaction + fee calc
├── ModelsMessage.swift                    # Chat message
├── ModelsMockData.swift                   # Sample data for all models
├── UtilitiesConstants.swift               # App-wide constants
└── ResourcesConfig.example.swift          # Config template
```

## Common Use Cases
- "Need 2 bags of ice - $10 - ASAP"
- "Anyone have an iPhone charger? $5"
- "Need a costume piece for tonight - $15"
- "Advil - $3"
- "Ping pong balls - $5"
- "Anyone have a speaker I can borrow for 2 hours? $20"
- "Need eggs for baking - $5"

---

# Development To-Do List

## Phase 1: Project Setup & Foundation
- [x] Xcode project with SwiftUI
- [x] Flat file organization (CategoryName.swift)
- [x] Info.plist with location permissions
- [x] Constants and config system
- [x] iOS-only target (iPhone + iPad)

## Phase 2: Core Data Models
- [x] User, School, Request, Offer, Transaction, Message models
- [x] Full validation, computed properties, Codable conformance
- [x] Comprehensive MockData with sample data for all models

## Phase 3: Authentication & Onboarding (Mock)
- [x] AppState (@Observable) as central state container
- [x] Welcome screen with demo login option
- [x] .edu email entry with school auto-detection
- [x] Profile setup (display name, phone)
- [x] RootView routing between onboarding and main app

## Phase 4: Location & Maps
- [x] LocationService wrapping CLLocationManager
- [x] Fallback to Stanford campus coordinates
- [x] MapKit view with color-coded request pins
- [x] 4-tab layout (Feed, Map, Activity, Profile)

## Phase 5: Request Creation
- [x] Full request form (description, price, urgency, radius, duration)
- [x] Platform fee preview
- [x] Reusable RequestCard component

## Phase 6: Feed & Activity
- [x] Searchable/filterable feed of nearby requests
- [x] Activity view with my requests + active transactions
- [x] Completed transaction history

## Phase 7: Request Detail & Negotiation
- [x] Dual-role detail view (requester vs fulfiller)
- [x] Make offer / counter-offer flow
- [x] Accept/decline logic
- [x] Negotiation history display

## Phase 8: Chat System
- [x] Message bubbles with timestamps
- [x] Real-time-style message list
- [x] Unread message counts
- [x] Chat list for active conversations

## Phase 9–10: Payment & Completion
- [x] Fee breakdown display (item + 10% fee capped at $2)
- [x] Dual confirmation UI
- [x] Transaction completes when both parties confirm
- [x] Celebration state on completion

## Phase 11: Profile & Settings
- [x] Profile with stats (rating, transaction count)
- [x] Transaction history list
- [x] Settings with notification toggles
- [x] Sign out returns to onboarding

## Phase 12: Push Notifications
- [ ] Configure APNs
- [ ] Notify nearby users on new requests

## Phase 13: Backend Development
- [ ] Choose backend framework
- [ ] Replace mock data with real API calls
- [ ] Real authentication (Firebase Auth or custom)
- [ ] Real payments (Stripe Connect)
- [ ] Real-time chat (WebSocket or Firebase)

## Phase 14: Testing & Polish
- [ ] Unit tests for models and AppState
- [ ] UI polish, animations, haptics
- [ ] Error handling and edge cases

## Phase 15: Pre-Launch
- [ ] TestFlight beta
- [ ] App Store submission

## Post-MVP Features (Future)
- [ ] Ratings and reviews system
- [ ] Category-based notification preferences
- [ ] Quiet hours functionality
- [ ] Dispute resolution flow
- [ ] Content moderation (keyword filtering)
- [ ] User reporting system
- [ ] Advanced notification targeting
- [ ] Analytics dashboard

---

*Last updated: February 6, 2026*
