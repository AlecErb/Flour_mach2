# Flour

A hyperlocal, real-time marketplace for immediate needs on college campuses.

![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS%2017+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Overview

Flour connects college students who need items immediately with nearby people who can fulfill those requests. Post a request, get offers from people nearby, negotiate, chat, meet up, and complete the exchange — all within minutes.

**Key Features:**
- Map-based request system with urgency levels
- Anonymous until match, then in-app chat
- Offer/counter-offer negotiation
- Dual-confirmation completion flow
- Platform fee calculation (10%, capped at $2)
- College-verified accounts (.edu email)

## Current Status

**Phases 1–11 complete** — the full user flow works end-to-end with mock data:

Onboard → Create request → Browse feed → Make offer → Accept → Chat → Confirm completion → View history → Sign out

All backend services (auth, payments, chat) are mocked in-memory via `AppState`. No Firebase or Stripe dependencies yet.

## Tech Stack

- **Platform:** iOS (SwiftUI, iOS 17+)
- **State:** `@Observable` with environment injection
- **Maps:** MapKit + CoreLocation
- **Backend:** Mock (in-memory) — real backend TBD
- **IDE:** Xcode 26.2

## Getting Started

### Prerequisites

- Xcode 15.0+ (developed on Xcode 26.2 beta)
- iOS 17.0+ device or simulator

### Run It

```bash
git clone https://github.com/AlecErb/Flour_mach2.git
cd Flour_mach2
open Flour_mach2.xcodeproj
```

Select an iPhone simulator and hit Run (Cmd+R). No dependencies to install — everything runs locally with mock data.

## Project Structure

All Swift files live in the project root with a flat naming convention:

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

## User Flows

### Requester
1. Tap "+" → enter item, price, urgency, radius
2. Post request → appears on map and feed
3. Review incoming offers → accept, decline, or counter
4. Chat with fulfiller → coordinate meetup
5. Both confirm completion → transaction done

### Fulfiller
1. Browse feed or map for nearby requests
2. Tap a request → make an offer
3. Negotiate if needed → get accepted
4. Chat with requester → coordinate meetup
5. Both confirm completion → transaction done

## Revenue Model

- **Platform Fee:** 10% of item price, capped at $2
- **Buyer pays:** Item price + platform fee
- **Seller receives:** Full agreed price

## Roadmap

- [x] Phase 1: Project setup & foundation
- [x] Phase 2: Core data models
- [x] Phase 3: Authentication & onboarding (mock)
- [x] Phase 4: Location & maps
- [x] Phase 5: Request creation
- [x] Phase 6: Feed & activity
- [x] Phase 7: Request detail & negotiation
- [x] Phase 8: Chat system
- [x] Phase 9: Payment display
- [x] Phase 10: Completion flow
- [x] Phase 11: Profile & settings
- [ ] Phase 12: Push notifications
- [ ] Phase 13: Backend development
- [ ] Phase 14: Testing & polish
- [ ] Phase 15: Pre-launch

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contact

- **Developer:** Alec Erb
- **Repository:** [github.com/AlecErb/Flour_mach2](https://github.com/AlecErb/Flour_mach2)

*Last updated: February 6, 2026*
