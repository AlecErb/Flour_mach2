# Stripe "Set Up Seller Payments" Error - Fix Guide

## Problem Summary

When clicking "Set Up Seller Payments" in the Profile view, the app shows:
> "Internet connection appears to be offline"

## Root Cause

The iOS app is trying to call Firebase Cloud Functions (`createConnectedAccount`), but:
- The functions are **not deployed** to Firebase Cloud
- The Firebase emulator is **not running** locally

Your Cloud Functions exist and are properly coded in `/functions/index.js`, but they need to be either:
1. Running in the Firebase Emulator (local development), OR
2. Deployed to Firebase Cloud (production)

## Quick Fix (For Local Development)

### Step 1: Install Firebase CLI

```bash
npm install -g firebase-tools
```

### Step 2: Install Function Dependencies

```bash
cd /Users/alec/Desktop/Swift/Flour/Flour_mach2/functions
npm install
```

### Step 3: Start the Firebase Emulator

From the project root:

```bash
cd /Users/alec/Desktop/Swift/Flour/Flour_mach2
firebase emulators:start
```

You should see:
```
✔  functions: Emulator started at http://localhost:5001
✔  firestore: Emulator started at http://localhost:8080
✔  View Emulator UI at http://localhost:4000
```

### Step 4: Test the App

1. Keep the emulator running in the terminal
2. Launch the iOS app in Xcode
3. Go to Profile → "Set Up Seller Payments"
4. The error should now be gone

The iOS app has been configured to automatically use `localhost:5001` in DEBUG builds (see `/Users/alec/Desktop/Swift/Flour/Flour_mach2/ServicesStripeService.swift`).

## Production Deployment (When Ready)

### Prerequisites

1. Get your Stripe API keys from https://dashboard.stripe.com/apikeys
2. Use **test mode** keys (start with `pk_test_` and `sk_test_`) for development

### Deploy Steps

1. **Login to Firebase:**
   ```bash
   firebase login
   ```

2. **Set Stripe Secret:**
   ```bash
   firebase functions:secrets:set STRIPE_SECRET
   ```
   Paste your Stripe secret key (starts with `sk_test_` or `sk_live_`)

3. **Deploy Functions:**
   ```bash
   firebase deploy --only functions
   ```

4. **Remove DEBUG emulator config** from `ServicesStripeService.swift` (or use release build)

## Understanding the Integration

### Payment Flow

1. **User clicks "Set Up Seller Payments"**
   → `ViewsProfileView.swift` line 88

2. **SellerOnboardingView appears**
   → Calls `appState.setupSellerAccount()`

3. **AppState calls StripeService**
   → `ServicesAppState.swift` line 454

4. **StripeService calls Firebase Function**
   → `ServicesStripeService.swift` line 24
   → HTTP call to `createConnectedAccount` Cloud Function

5. **Cloud Function creates Stripe account**
   → `functions/index.js` line 15-68
   → Returns onboarding URL for user to complete setup

6. **User completes Stripe onboarding in Safari**
   → Returns to app
   → Status checked via `checkAccountStatus` function

### Why Use Cloud Functions?

- **Security**: Your Stripe secret key never touches the iOS app
- **PCI Compliance**: Stripe API calls happen server-side
- **Flexibility**: Easy to update payment logic without app updates
- **Webhooks**: Stripe can notify your backend of payment events

### Current Files

| File | Purpose |
|------|---------|
| `/functions/index.js` | Cloud Functions (backend payment logic) |
| `/ServicesStripeService.swift` | iOS service to call Cloud Functions |
| `/ServicesAppState.swift` | App state management for payments |
| `/ViewsSellerOnboardingView.swift` | UI for seller onboarding |
| `/ViewsProfileView.swift` | Profile with payment setup button |

## Testing Without Real Stripe

If you want to test the UI flow without actually calling Stripe:

1. Keep the emulator running (it won't fail even without Stripe keys)
2. The Cloud Functions will throw errors, but you can modify them to return mock data
3. Or, set test mode Stripe keys in Firebase secrets

## Next Steps After This Fix

1. Get Stripe test API keys
2. Configure Stripe secret in Firebase
3. Test seller onboarding flow end-to-end
4. Implement payment capture with escrow logic
5. Add dual confirmation before releasing funds to seller
6. Configure Stripe webhook for production

## Troubleshooting

### Emulator won't start
- Make sure port 5001, 8080, and 4000 are not in use
- Check `functions/package.json` has all dependencies
- Run `npm install` in the functions directory

### Still getting "offline" error
- Verify emulator is running (check terminal output)
- Check iOS app is in DEBUG mode (not Release)
- Restart Xcode and rebuild the app

### Function throws "STRIPE_SECRET not defined"
- For emulator: Create `functions/.secret.local` with `STRIPE_SECRET=sk_test_...`
- For production: Use `firebase functions:secrets:set STRIPE_SECRET`

## Questions?

The Cloud Functions are well-structured and follow Stripe best practices for marketplace payments. Once the emulator or deployment is set up, the integration should work smoothly.
