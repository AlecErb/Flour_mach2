# Stripe Payment Expert Memory

## Current Integration Status

### Architecture Decisions
- **Stripe Connect Type**: Express accounts (individual sellers, daily payouts)
- **Backend**: Firebase Cloud Functions (Node.js)
- **Payment Flow**: Direct charges with application fees (platform fee collected upfront)
- **Escrow Pattern**: Not yet implemented (will use `capture_method: 'manual'` on PaymentIntent)

### Implementation State
- Cloud Functions defined in `/functions/index.js` with 4 endpoints:
  - `createConnectedAccount` - Onboard sellers
  - `checkAccountStatus` - Verify onboarding completion
  - `createPaymentIntent` - Process payments
  - `stripeWebhook` - Handle payment events
- iOS StripeService uses FirebaseFunctions SDK
- Functions NOT deployed - emulator or deployment required

### Common Issues

#### "Internet connection appears to be offline" Error
**Cause**: Firebase Cloud Functions not running (neither deployed nor emulator)
**Solution**:
1. For local dev: `firebase emulators:start` from project root
2. For production: `firebase deploy --only functions` after setting `STRIPE_SECRET`
3. iOS app configured to use emulator in DEBUG builds (localhost:5001)

### Fee Calculation Pattern
- Buyer pays: item price + 10% platform fee (capped at $2)
- Seller receives: full agreed item price (no deductions)
- Platform keeps: the 10% fee
- Implementation: `application_fee_amount` in PaymentIntent

### Security Considerations
- Stripe secret stored as Firebase Secret (not in code)
- Client never touches secret key
- PaymentIntents created server-side only
- Webhook signature verification required

### Next Steps
1. Deploy functions or start emulator
2. Set STRIPE_SECRET in Firebase (test or live key)
3. Test seller onboarding flow
4. Implement escrow (manual capture)
5. Add dual confirmation before capture
6. Configure webhook endpoint in Stripe Dashboard

## File Locations
- iOS StripeService: `/ServicesStripeService.swift`
- Cloud Functions: `/functions/index.js`
- AppState payment methods: `/ServicesAppState.swift` (lines 451-525)
- Seller onboarding UI: `/ViewsSellerOnboardingView.swift`
