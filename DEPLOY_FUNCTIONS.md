# Deploying Firebase Cloud Functions

## Prerequisites

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Verify your Firebase project:
   ```bash
   firebase projects:list
   ```

## Set Up Stripe Secret

Your Cloud Functions need the Stripe API key as a secret:

```bash
# Set the Stripe secret key (get from https://dashboard.stripe.com/apikeys)
firebase functions:secrets:set STRIPE_SECRET
```

When prompted, paste your Stripe **secret key** (starts with `sk_test_` or `sk_live_`).

## Deploy the Functions

From the project root:

```bash
firebase deploy --only functions
```

This will deploy:
- `createConnectedAccount`
- `checkAccountStatus`
- `createPaymentIntent`
- `stripeWebhook`

## Verify Deployment

After deployment, you'll see URLs like:
```
✔  functions[us-central1-createConnectedAccount] https://us-central1-YOUR-PROJECT.cloudfunctions.net/createConnectedAccount
```

The iOS app will automatically use these URLs when calling Firebase Functions.

## Configure Stripe Webhook (for Production)

1. Go to Stripe Dashboard → Developers → Webhooks
2. Add endpoint: `https://us-central1-YOUR-PROJECT.cloudfunctions.net/stripeWebhook`
3. Select events: `payment_intent.succeeded`, `payment_intent.payment_failed`
4. Copy the webhook signing secret
5. Set it in Firebase:
   ```bash
   firebase functions:config:set stripe.webhook_secret="whsec_..."
   ```

## Testing

1. Launch the iOS app
2. Go to Profile → "Set Up Seller Payments"
3. The app will now successfully call the deployed Cloud Functions

## Logs

View function logs:
```bash
firebase functions:log
```
