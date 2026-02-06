# Flour - Design Document

## Overview

A hyperlocal, real-time marketplace for immediate needs. Users can request items from nearby people, offer a price, and complete exchanges in person. Think Uber meets Venmo for borrowing/buying from neighbors.

**App Name:** Flour
**Target Platform:** iOS (SwiftUI)
**Initial Market:** College campuses (starting with Greek life communities)
**Radius:** ~10 minute walk

---

## Why College Campuses / Greek Life?

| Advantage | Details |
|-----------|---------|
| High density | Students live in close proximity, guaranteed nearby users |
| Tech savvy | Quick to understand and adopt new apps |
| Word of mouth | Strong social networks, viral potential |
| Clear use cases | Party supplies, chargers, study materials, everyday items |

---

## Core User Flows

### Sign Up
1. Enter .edu email → verification sent
2. Select school (dropdown)
3. Phone number verification (SMS)
4. Create display name

### Requester Flow
1. Open app → See map centered on your location
2. Tap "New Request"
3. Enter:
   - Item description (text)
   - Offer price ($)
   - Urgency (ASAP / 30 min / 1 hour / flexible)
   - Radius (default: 10 min walk)
4. Post request → Notification sent to nearby users
5. View incoming responses (accept, counter-offers)
6. Negotiate via counter-offers until agreement or decline
7. Accept a fulfiller → Names revealed, in-app chat unlocked
7. Coordinate meetup via chat
8. Meet, exchange, both tap "Complete"
9. Payment auto-transfers (requester pays price + platform fee)

### Fulfiller Flow
1. Receive push notification: "Someone nearby needs [item] - $[price]"
2. Tap to view details: distance, urgency, offer
3. Accept / Counter / Ignore
4. If countered → Back-and-forth negotiation until one party accepts or declines
5. If accepted → See requester's name, chat unlocked
5. Coordinate meetup via in-app chat
6. Exchange item, tap "Complete"
7. Receive full payment (no fees deducted from seller)

### Feed View (Venmo-style)
- Nearby open requests (scrollable list)
- Your active transactions
- Option: recently completed transactions (social proof)

---

## Key Design Decisions

### Identity & Privacy
- **Anonymous until match:** Requests show "Someone nearby needs [item]" - no identifying info
- **Reveal on match:** Once accepted, both parties see display name only
- **No house affiliation required or displayed**
- **Profile:** Display name, school, rating (post-MVP)

### Payments
- **In-app payments** via Stripe
- **Buyer pays platform fee** (seller receives full asking price)
- **Fee structure:** Hybrid - 10% with $2 cap (e.g., $5 item = $0.50 fee, $30 item = $2 fee)
- Payment held in escrow until both parties confirm completion

### Communication
- **In-app chat only** - phone numbers never shared
- Chat unlocks after match is accepted
- Keeps users on platform, protects privacy

### Notifications
- Push notifications to users within radius
- Future: opt-in categories, quiet hours, smart targeting

### Trust & Safety
- .edu email required (college students only)
- Phone verification required
- Report/block functionality
- Ratings system (post-MVP)

### Content Policy
- Alcohol and prohibited items: Banned in Terms of Service
- MVP: No active moderation (revisit post-launch)
- Future: Keyword filtering, user reporting, manual review

---

## Revenue Model

**Buyer pays a service fee on each transaction.**

| Component | Who Pays | Amount |
|-----------|----------|--------|
| Item price | Buyer → Seller | Agreed price |
| Platform fee | Buyer → Flour | 10% of item price, capped at $2 |
| Stripe processing | Flour absorbs or passes to buyer | ~2.9% + $0.30 |

**Examples:**
- $5 item → $0.50 fee → Buyer pays $5.50, Seller receives $5
- $15 item → $1.50 fee → Buyer pays $16.50, Seller receives $15
- $30 item → $2.00 fee (capped) → Buyer pays $32, Seller receives $30

Seller always receives their full agreed price.

---

## MVP Scope

### Include in MVP
- [ ] Map view with request creation
- [ ] Push notifications to nearby users
- [ ] Accept/decline/counter flow
- [ ] In-app chat (unlocks after match)
- [ ] In-app payment processing (Stripe)
- [ ] Basic profile (display name, school)
- [ ] Phone + .edu email verification
- [ ] "Complete" confirmation from both parties
- [ ] Simple feed of nearby requests

### Defer to Post-MVP
- [ ] Category-based notification preferences
- [ ] Ratings and reviews
- [ ] Dispute resolution flow
- [ ] Content moderation system
- [ ] Advanced notification targeting
- [ ] Quiet hours

---

## Common Use Cases

- "Need 2 bags of ice - $10 - ASAP"
- "Anyone have an iPhone charger? $5"
- "Need a costume piece for tonight - $15"
- "Advil - $3"
- "Ping pong balls - $5"
- "Anyone have a speaker I can borrow for 2 hours? $20"
- "Need eggs for baking - $5"

---

## Technical Architecture (High-Level)

### Frontend
- **Platform:** iOS (SwiftUI)
- **Maps:** MapKit
- **Auth:** Firebase Auth or custom
- **Push Notifications:** APNs
- **Real-time Chat:** Firebase Realtime DB or custom WebSocket

### Backend
- **API:** TBD (Node.js, Python/FastAPI, or serverless)
- **Database:** PostgreSQL or Firebase Firestore
- **Payments:** Stripe Connect (for marketplace payouts)
- **Real-time:** WebSockets or Firebase Realtime DB for live updates + chat

### Key Data Models

```
User
├── id
├── display_name
├── email (.edu)
├── phone
├── school_id
├── created_at
└── rating (post-MVP)

Request
├── id
├── requester_id
├── item_description
├── offer_price
├── urgency (enum: asap, 30min, 1hour, flexible)
├── radius_meters
├── location (lat/lng)
├── status (enum: open, negotiating, matched, completed, cancelled, expired)
├── fulfiller_id (nullable)
├── created_at
├── expires_at
└── duration_hours (default: 2, user-configurable)

Offer (for negotiation)
├── id
├── request_id
├── user_id (the person making the offer)
├── amount
├── status (enum: pending, accepted, declined, countered)
├── parent_offer_id (nullable, for counter-offers)
└── created_at

Transaction
├── id
├── request_id
├── requester_id
├── fulfiller_id
├── item_price
├── platform_fee
├── total_charged (item_price + platform_fee)
├── status (enum: pending, completed, disputed, refunded)
├── requester_confirmed (bool)
├── fulfiller_confirmed (bool)
└── completed_at

Message
├── id
├── transaction_id
├── sender_id
├── content
├── created_at
└── read (bool)

School
├── id
├── name
└── domain (.edu domain)
```

---

## Screen Inventory (MVP)

1. **Onboarding**
   - Email entry + verification
   - School selection
   - Phone verification
   - Display name creation

2. **Home (Map View)**
   - Map centered on user
   - "New Request" button (prominent)
   - Toggle to Feed view
   - Active transaction indicator

3. **Feed View**
   - List of nearby open requests
   - Active transactions section
   - Pull to refresh

4. **Create Request**
   - Item description input
   - Price input
   - Urgency selector
   - Radius slider (optional, default 10 min)
   - Duration selector (default 2 hours, adjustable)
   - Post button

5. **Request Detail (Requester)**
   - Request info
   - Incoming responses list
   - Accept/decline buttons for each response
   - After match: Chat interface + Complete button

6. **Request Detail (Fulfiller)**
   - Item, price, distance, urgency
   - Accept / Counter / Ignore buttons
   - After match: Chat interface + Complete button

7. **Chat Screen**
   - Simple messaging interface
   - Accessible from active transaction
   - "Mark Complete" button

8. **Profile**
   - Display name, school
   - Transaction history
   - Settings (notifications, payment methods)
   - Log out

---

## Next Steps

1. ~~Finalize open questions~~ ✓
2. Create wireframes for each screen
3. Define API endpoints
4. Set up iOS project + backend infrastructure
5. Build authentication flow
6. Build core request/fulfill flow
7. Build in-app chat
8. Integrate Stripe payments
9. Beta test on one campus

---

## Open Questions (Resolved)

| Question | Decision |
|----------|----------|
| House visibility | No house affiliation - not required or shown |
| Alcohol policy | Prohibit in ToS, no active moderation for MVP |
| Revenue model | Buyer pays platform fee, seller gets full amount |
| Chat | In-app chat, no phone number sharing |
| App name | **Flour** |
| Fee structure | 10% with $2 cap |
| Counter-offers | Continuous back-and-forth negotiation allowed |
| Request duration | Default 2 hours, user-configurable |

---

*Last updated: 2026-02-05*
