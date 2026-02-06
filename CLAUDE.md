# Flour - AI Assistant Context

## Project Overview

**Flour** is a hyperlocal, real-time marketplace iOS app for immediate needs, targeting college campuses (initially Greek life communities). Users can request items from nearby people, offer prices, and complete exchanges in person within a ~10 minute walk radius.

**Tech Stack:**
- **Platform:** iOS (SwiftUI)
- **Maps:** MapKit
- **Payments:** Stripe Connect
- **Real-time Chat:** Firebase Realtime DB or WebSocket
- **Auth:** Firebase Auth or custom
- **Push Notifications:** APNs
- **Backend:** TBD (Node.js, Python/FastAPI, or serverless)
- **Database:** PostgreSQL or Firebase Firestore

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

## Core Data Models

```swift
User {
    id, display_name, email (.edu), phone, school_id, created_at, rating
}

Request {
    id, requester_id, item_description, offer_price, urgency (asap/30min/1hour/flexible),
    radius_meters, location (lat/lng), status (open/negotiating/matched/completed/cancelled/expired),
    fulfiller_id (nullable), created_at, expires_at, duration_hours (default: 2)
}

Offer {
    id, request_id, user_id, amount, status (pending/accepted/declined/countered),
    parent_offer_id (nullable), created_at
}

Transaction {
    id, request_id, requester_id, fulfiller_id, item_price, platform_fee, total_charged,
    status (pending/completed/disputed/refunded), requester_confirmed, fulfiller_confirmed,
    completed_at
}

Message {
    id, transaction_id, sender_id, content, created_at, read
}

School {
    id, name, domain
}
```

## MVP Screen Inventory

1. **Onboarding:** Email verification → School selection → Phone verification → Display name
2. **Home (Map View):** Map centered on user, "New Request" button, toggle to Feed
3. **Feed View:** List of nearby open requests, active transactions
4. **Create Request:** Item description, price, urgency, radius, duration, post
5. **Request Detail (Requester):** Request info, incoming responses, accept/decline, chat after match
6. **Request Detail (Fulfiller):** Item details, accept/counter/ignore, chat after match
7. **Chat Screen:** Messaging interface, "Mark Complete" button
8. **Profile:** Display name, school, transaction history, settings, logout

## MVP Checklist

### Must-Have Features
- [ ] Map view with request creation
- [ ] Push notifications to nearby users
- [ ] Accept/decline/counter flow
- [ ] In-app chat (unlocks after match)
- [ ] In-app payment processing (Stripe)
- [ ] Basic profile (display name, school)
- [ ] Phone + .edu email verification
- [ ] "Complete" confirmation from both parties
- [ ] Simple feed of nearby requests

### Post-MVP (Deferred)
- Category-based notification preferences
- Ratings and reviews
- Dispute resolution flow
- Content moderation system
- Advanced notification targeting
- Quiet hours

## Content Policy
- Alcohol and prohibited items: Banned in ToS
- MVP: No active moderation (revisit post-launch)
- Future: Keyword filtering, user reporting, manual review

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
- [ ] Create new Xcode project (iOS, SwiftUI)
  - [ ] Set minimum deployment target (iOS 17.0+)
  - [ ] Configure bundle identifier
  - [ ] Set up project organization structure
- [ ] Set up folder structure
  - [ ] Models/
  - [ ] Views/
  - [ ] ViewModels/
  - [ ] Services/
  - [ ] Utilities/
  - [ ] Resources/
- [ ] Add necessary dependencies
  - [ ] Firebase SDK (Auth, Firestore, Realtime Database)
  - [ ] Stripe iOS SDK
  - [ ] Swift Package Manager configuration
- [ ] Configure Info.plist requirements
  - [ ] Location usage descriptions
  - [ ] Camera usage (future profile photos)
  - [ ] Push notification capabilities
- [ ] Set up .gitignore (API keys, secrets)
- [ ] Create development environment config file

## Phase 2: Core Data Models ✓
- [x] Define User model
- [x] Define Request model with urgency enum
- [x] Define Offer model for negotiation
- [x] Define Transaction model
- [x] Define Message model
- [x] Define School model
- [x] Create mock data for testing/previews

## Phase 3: Authentication & Onboarding
- [ ] Set up Firebase Authentication
- [ ] Build email entry + verification view
- [ ] Build school selection view (dropdown/picker)
- [ ] Build phone verification view (SMS)
- [ ] Build display name creation view
- [ ] Create authentication service/manager
- [ ] Implement session persistence
- [ ] Add "Sign Out" functionality

## Phase 4: Location & Maps
- [ ] Set up MapKit integration
- [ ] Request location permissions
- [ ] Build map view centered on user
- [ ] Add location service wrapper
- [ ] Implement radius calculation utilities
- [ ] Test location updates

## Phase 5: Request Creation Flow
- [ ] Build "Create Request" screen
  - [ ] Item description text input
  - [ ] Price input with validation
  - [ ] Urgency selector UI
  - [ ] Radius slider (default 10 min walk)
  - [ ] Duration selector (default 2 hours)
- [ ] Implement request posting logic
- [ ] Connect to backend API
- [ ] Add form validation

## Phase 6: Feed & Request Display
- [ ] Build feed view (list of nearby requests)
- [ ] Display request cards with key info
- [ ] Add pull-to-refresh functionality
- [ ] Filter by distance/urgency
- [ ] Show active transactions section
- [ ] Implement real-time updates

## Phase 7: Request Detail & Negotiation
- [ ] Build request detail view (requester perspective)
  - [ ] Display incoming offers
  - [ ] Accept/decline buttons
  - [ ] Counter-offer input
- [ ] Build request detail view (fulfiller perspective)
  - [ ] Accept/counter/ignore buttons
  - [ ] Counter-offer input
- [ ] Implement negotiation state management
- [ ] Add real-time offer updates
- [ ] Show negotiation history

## Phase 8: Chat System
- [ ] Set up Firebase Realtime Database for chat
- [ ] Build chat view UI
- [ ] Implement message sending
- [ ] Implement message receiving (real-time)
- [ ] Add message read status
- [ ] Unlock chat only after match accepted
- [ ] Add "Mark Complete" button in chat

## Phase 9: Payment Integration
- [ ] Set up Stripe Connect account
- [ ] Integrate Stripe iOS SDK
- [ ] Build payment method entry screen
- [ ] Implement payment capture on acceptance
- [ ] Hold payment in escrow
- [ ] Release payment on dual confirmation
- [ ] Calculate and apply platform fee (10%, $2 cap)
- [ ] Handle payment failures

## Phase 10: Completion Flow
- [ ] Build completion confirmation UI (both parties)
- [ ] Implement dual confirmation logic
- [ ] Trigger payment release
- [ ] Update transaction status
- [ ] Show completion success state
- [ ] Archive completed transactions

## Phase 11: Profile & Settings
- [ ] Build basic profile view
  - [ ] Display name
  - [ ] School
  - [ ] Transaction history
- [ ] Build settings view
  - [ ] Notification preferences
  - [ ] Payment methods management
  - [ ] Account settings
- [ ] Implement sign-out functionality

## Phase 12: Push Notifications
- [ ] Configure APNs in Xcode
- [ ] Set up push notification certificates
- [ ] Implement notification handling
- [ ] Send notifications to nearby users on request creation
- [ ] Handle notification tap (deep linking)
- [ ] Request notification permissions

## Phase 13: Backend Development
- [ ] Choose backend framework (Node.js/FastAPI/serverless)
- [ ] Set up database (PostgreSQL/Firestore)
- [ ] Design and implement REST/GraphQL API
  - [ ] User endpoints (CRUD)
  - [ ] Request endpoints (CRUD, nearby search)
  - [ ] Offer endpoints (negotiation)
  - [ ] Transaction endpoints
  - [ ] Chat endpoints (or use Firebase)
- [ ] Implement location-based queries
- [ ] Add authentication middleware
- [ ] Set up WebSocket server (if not using Firebase)
- [ ] Deploy to staging environment

## Phase 14: Testing & Polish
- [ ] Write unit tests for core models
- [ ] Write unit tests for services
- [ ] Test authentication flow end-to-end
- [ ] Test request creation and fulfillment flow
- [ ] Test negotiation flow
- [ ] Test payment flow
- [ ] Test chat functionality
- [ ] Add loading states
- [ ] Add error handling and user feedback
- [ ] Polish UI/UX (animations, haptics)
- [ ] Test on real devices

## Phase 15: Pre-Launch
- [ ] Create App Store assets (icon, screenshots)
- [ ] Write Terms of Service
- [ ] Write Privacy Policy
- [ ] Set up TestFlight for beta testing
- [ ] Recruit beta testers (one campus)
- [ ] Collect and implement beta feedback
- [ ] Submit to App Store review

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

*Created: 2026-02-05*
