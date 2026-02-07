# Complete Stripe + Firebase Setup Guide

All the code files are ready. Follow these steps in order.

---

## Part 1: Complete Firebase Setup (Interactive - You Need to Run This)

**Open Terminal and run these commands:**

```bash
cd /Users/alec/Desktop/Swift/Flour/Flour_mach2

# Step 1: Login to Firebase
npx firebase login
```

This opens a browser. Login with your Google account (the one you used for Firebase console).

**Step 2: Link to your Firebase project**

You need to create a `.firebaserc` file that tells Firebase CLI which project to use:

```bash
# Option A: Use init (interactive, will ask questions)
npx firebase init

# When prompted:
# - "Which Firebase features?" → Use arrow keys to select "Functions" (spacebar to select), then Enter
# - "Use an existing project" → Yes
# - "Select a project" → Choose your Firebase project
# - "What language?" → JavaScript
# - "Use ESLint?" → Yes
# - "Overwrite existing files?" → **NO** (we already created them)
# - "Install dependencies?" → Yes
```

**OR Option B: Create .firebaserc manually**

If you know your Firebase project ID, create this file:

```bash
echo '{
  "projects": {
    "default": "YOUR_PROJECT_ID_HERE"
  }
}' > .firebaserc
```

Replace `YOUR_PROJECT_ID_HERE` with your actual Firebase project ID (find it in Firebase Console → Project Settings).

---

## Part 2: Get Your Stripe API Keys

1. Go to [dashboard.stripe.com](https://dashboard.stripe.com)
2. Make sure you're in **Test mode** (toggle in top right)
3. Click **"Developers"** in left sidebar → **"API keys"**
4. You'll see:
   - **Publishable key**: `pk_test_...` (safe for client)
   - **Secret key**: `sk_test_...` (NEVER put in app)
5. Copy the **Secret key** (click "Reveal test key")

---

## Part 3: Set Stripe Secret Key in Firebase

**In Terminal:**

```bash
npx firebase functions:config:set stripe.secret="sk_test_YOUR_KEY_HERE"
```

Replace `sk_test_YOUR_KEY_HERE` with your actual test secret key.

**Verify it worked:**

```bash
npx firebase functions:config:get
```

You should see:
```json
{
  "stripe": {
    "secret": "sk_test_..."
  }
}
```

---

## Part 4: Install Dependencies

```bash
cd functions
npm install
cd ..
```

This installs Stripe SDK and Firebase Admin SDK.

---

## Part 5: Deploy to Firebase

```bash
npx firebase deploy --only functions
```

This uploads your Cloud Functions to Google's servers. Takes 2-3 minutes.

**Expected output:**

```
✔  Deploy complete!

Functions:
  createConnectedAccount(us-central1)
  checkAccountStatus(us-central1)
  createPaymentIntent(us-central1)
  stripeWebhook(us-central1)
```

Copy the webhook URL from the output (ends with `/stripeWebhook`). You'll need it for the next step.

---

## Part 6: Configure Stripe Webhook (Optional for MVP)

This lets Stripe notify your app when payments succeed/fail.

1. Go to [dashboard.stripe.com/webhooks](https://dashboard.stripe.com/webhooks)
2. Click **"Add endpoint"**
3. Paste your webhook URL: `https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/stripeWebhook`
4. Select events to listen for:
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`
   - `account.updated`
5. Click **"Add endpoint"**
6. Click to reveal your **"Signing secret"** (starts with `whsec_`)
7. Set it in Firebase:

```bash
npx firebase functions:config:set stripe.webhook_secret="whsec_YOUR_SECRET"
npx firebase deploy --only functions
```

---

## Part 7: Verify Everything Works

**Test the functions locally (optional):**

```bash
npx firebase emulators:start --only functions
```

This runs your functions locally at `http://localhost:5001`. Press Ctrl+C to stop.

**Or just deploy and test from your iOS app** (recommended).

---

## What You Built

You now have 4 Cloud Functions running on Google's servers:

### 1. `createConnectedAccount`
- **What**: Creates a Stripe account for sellers
- **When**: User taps "Become a seller" or "Set up payments"
- **Returns**: URL to Stripe's onboarding form

### 2. `checkAccountStatus`
- **What**: Checks if seller completed onboarding
- **When**: After user returns from Stripe onboarding
- **Returns**: `{ onboardingComplete: true/false }`

### 3. `createPaymentIntent`
- **What**: Creates a payment when buyer accepts an offer
- **When**: User taps "Pay Now" or "Confirm Payment"
- **Returns**: `clientSecret` for Stripe iOS SDK

### 4. `stripeWebhook`
- **What**: Receives notifications from Stripe (payment success/failure)
- **When**: Stripe automatically calls this after payment events
- **Updates**: Transaction status in Firestore

---

## Next Steps

Once deployed, you need to:

1. **Add Stripe iOS SDK to Xcode** (I'll do this)
2. **Create StripeService in Swift** (I'll write this)
3. **Update AppState to store Stripe account IDs** (I'll do this)
4. **Add "Set up payments" flow to Profile view** (I'll do this)
5. **Add payment UI when offer is accepted** (I'll do this)

---

## Troubleshooting

**"Error: HTTP Error: 401, Request had invalid authentication credentials"**
- Run `npx firebase login` again
- Make sure you're logged in with the right Google account

**"Functions deploy failed"**
- Check you set the Stripe secret: `npx firebase functions:config:get`
- Make sure `functions/package.json` exists
- Try `cd functions && npm install && cd ..`

**"Cannot find module 'stripe'"**
- Run `cd functions && npm install stripe && cd ..`

**"Project not found"**
- Check `.firebaserc` has the right project ID
- Or run `npx firebase use --add` and select your project

---

## Important Files Created

```
Flour_mach2/
├── firebase.json                    # Firebase config
├── .firebaserc                      # Which Firebase project (YOU create this)
├── functions/
│   ├── index.js                     # Cloud Functions code (4 functions)
│   ├── package.json                 # Node.js dependencies
│   ├── .eslintrc.js                 # Code linting rules
│   └── .gitignore                   # Ignore node_modules
└── STRIPE_SETUP_COMPLETE.md         # This file
```

---

**Once you've completed all steps, come back and I'll integrate the iOS side (Stripe SDK + Swift code).**
