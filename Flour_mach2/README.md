# Flour 🌾

A hyperlocal, real-time marketplace for immediate needs on college campuses.

![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS%2017.0+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Overview

Flour connects college students who need items immediately with nearby people who can fulfill those requests. Think Uber meets Venmo for borrowing/buying from neighbors.

**Key Features:**
- 🗺️ Real-time map-based request system
- 💬 Anonymous until match, then in-app chat
- 💰 Integrated payments with Stripe
- 🔔 Push notifications to nearby users
- 🤝 Negotiation system with counter-offers
- 🎓 College-verified accounts (.edu email)

## Tech Stack

- **Frontend:** SwiftUI (iOS 17.0+)
- **Maps:** MapKit
- **Payments:** Stripe Connect
- **Real-time Chat:** Firebase Realtime Database
- **Authentication:** Firebase Auth
- **Backend:** TBD (Node.js/Python/Serverless)
- **Database:** PostgreSQL or Firebase Firestore
- **Push Notifications:** Apple Push Notification Service (APNs)

## Project Status

🚧 **Currently in Development** - Phase 1: Project Setup

See [CLAUDE.md](CLAUDE.md) for detailed development roadmap and context.

## Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 17.0+ deployment target
- CocoaPods or Swift Package Manager
- Firebase account
- Stripe account (for payments)

### Installation

```bash
# Clone the repository
git clone https://github.com/AlecErb/Flour_mach2.git
cd Flour_mach2

# Install dependencies (will be added in Phase 1)
# Swift Package Manager dependencies will be managed in Xcode

# Open the project
open Flour.xcodeproj
```

### Configuration

1. **Firebase Setup**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Download `GoogleService-Info.plist` and add it to the project
   - Enable Authentication, Firestore, and Realtime Database

2. **Stripe Setup**
   - Create a Stripe account at [stripe.com](https://stripe.com)
   - Get your publishable and secret keys
   - Add keys to `Config.swift` (not tracked in git)

3. **Environment Variables**
   - Copy `Config.example.swift` to `Config.swift`
   - Fill in your API keys and configuration

## Project Structure

```
Flour/
├── Models/              # Data models (User, Request, Offer, etc.)
├── Views/               # SwiftUI views
│   ├── Onboarding/     # Sign up and verification flows
│   ├── Home/           # Map view and feed
│   ├── Requests/       # Request creation and detail views
│   ├── Chat/           # In-app messaging
│   └── Profile/        # User profile and settings
├── ViewModels/          # View models and business logic
├── Services/            # API clients, Firebase, Stripe integration
├── Utilities/           # Helpers, extensions, constants
└── Resources/           # Assets, fonts, etc.
```

## Key User Flows

### Requester Flow
1. Tap "New Request" on map
2. Enter item description, price, urgency
3. Post → nearby users notified
4. Review incoming offers/counter-offers
5. Accept a fulfiller → chat unlocks
6. Coordinate meetup
7. Complete exchange → payment transfers

### Fulfiller Flow
1. Receive push notification about nearby request
2. View details: item, price, distance
3. Accept, counter-offer, or ignore
4. If accepted → chat unlocks
5. Coordinate meetup
6. Complete exchange → receive payment

## Revenue Model

- **Platform Fee:** 10% of item price, capped at $2
- **Buyer pays:** Item price + platform fee
- **Seller receives:** Full agreed price (no fees deducted)

**Examples:**
- $5 item → $0.50 fee → Buyer pays $5.50
- $30 item → $2.00 fee (capped) → Buyer pays $32

## Privacy & Safety

- ✅ .edu email verification required
- ✅ Phone number verification
- ✅ Anonymous until match accepted
- ✅ In-app chat only (no phone numbers shared)
- ✅ Prohibited items banned in Terms of Service
- 🔜 Ratings and reviews (post-MVP)
- 🔜 Report and block functionality

## Contributing

This is currently a private project in early development. Contributing guidelines will be added in the future.

## Roadmap

- [x] Design document completed
- [x] GitHub repository setup
- [ ] Phase 1: Project setup and foundation
- [ ] Phase 2: Core data models
- [ ] Phase 3: Authentication & onboarding
- [ ] Phase 4: Location & maps
- [ ] Phase 5: Request creation flow
- [ ] Phase 6: Feed & request display
- [ ] Phase 7: Request detail & negotiation
- [ ] Phase 8: Chat system
- [ ] Phase 9: Payment integration
- [ ] Phase 10: Completion flow
- [ ] Phase 11: Profile & settings
- [ ] Phase 12: Push notifications
- [ ] Phase 13: Backend development
- [ ] Phase 14: Testing & polish
- [ ] Phase 15: Pre-launch preparation

See [CLAUDE.md](CLAUDE.md) for detailed task breakdowns.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contact

- **Developer:** Alec Erb
- **Repository:** [github.com/AlecErb/Flour_mach2](https://github.com/AlecErb/Flour_mach2)

---

**Target Launch:** Beta testing on one college campus, then gradual rollout.

*Last updated: February 5, 2026*
