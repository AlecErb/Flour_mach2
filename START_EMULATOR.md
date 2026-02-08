# Starting Firebase Emulator for Local Testing

## Prerequisites

1. Install Firebase CLI globally:
   ```bash
   npm install -g firebase-tools
   ```

2. Install function dependencies:
   ```bash
   cd functions
   npm install
   ```

## Start the Emulator

From the project root:

```bash
firebase emulators:start
```

This will start:
- **Functions emulator** on http://localhost:5001
- **Firestore emulator** on http://localhost:8080
- **Emulator UI** on http://localhost:4000

## Connect iOS App to Emulator

The app needs to be configured to use the local emulator instead of production Firebase.

Add this to `ServicesStripeService.swift` after line 11 (in the init or a setup method):

```swift
// Use local emulator in debug builds
#if DEBUG
functions.useEmulator(withHost: "localhost", port: 5001)
#endif
```

## Testing Stripe Integration

When the emulator is running:
1. Launch the iOS app
2. Go to Profile → "Set Up Seller Payments"
3. The app will call your local Cloud Functions
4. You can see function logs in the terminal

## Stopping the Emulator

Press `Ctrl+C` in the terminal where the emulator is running.

## Notes

- The emulator does NOT actually call Stripe - you'll need to mock the Stripe responses or use Stripe test mode
- Set `STRIPE_SECRET` as an environment variable or use `.env` file in functions directory
