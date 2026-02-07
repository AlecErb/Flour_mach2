const {onCall, HttpsError} = require('firebase-functions/v2/https');
const {onRequest} = require('firebase-functions/v2/https');
const {defineSecret} = require('firebase-functions/params');
const admin = require('firebase-admin');

admin.initializeApp();

// Define Stripe secret as a Cloud Secret
const stripeSecret = defineSecret('STRIPE_SECRET');

/**
 * Create a Stripe Connected Account for a seller
 * Called when a user wants to become a fulfiller and receive payments
 */
exports.createConnectedAccount = onCall({secrets: [stripeSecret]}, async (request) => {
	// Verify user is authenticated
	if (!request.auth) {
		throw new HttpsError('unauthenticated', 'User must be logged in');
	}

	// Initialize Stripe with secret
	const stripe = require('stripe')(stripeSecret.value());

	const userId = request.auth.uid;
	const {email} = request.data;

	try {
		// Create Stripe Express connected account
		const account = await stripe.accounts.create({
			type: 'express',
			email: email,
			capabilities: {
				card_payments: {requested: true},
				transfers: {requested: true},
			},
			business_type: 'individual',
			settings: {
				payouts: {
					schedule: {
						interval: 'daily', // Pay sellers daily (faster than weekly)
					},
				},
			},
		});

		// Save Stripe account ID to Firestore user document
		await admin.firestore().collection('users').doc(userId).update({
			stripeAccountId: account.id,
			stripeOnboardingComplete: false,
		});

		// Create account link for onboarding flow
		const accountLink = await stripe.accountLinks.create({
			account: account.id,
			refresh_url: 'flour://stripe/reauth', // Deep link if user needs to refresh
			return_url: 'flour://stripe/return', // Deep link after completion
			type: 'account_onboarding',
		});

		return {
			accountId: account.id,
			accountLinkUrl: accountLink.url,
		};
	} catch (error) {
		console.error('Error creating connected account:', error);
		throw new HttpsError('internal', error.message);
	}
});

/**
 * Check if a connected account has completed onboarding
 */
exports.checkAccountStatus = onCall({secrets: [stripeSecret]}, async (request) => {
	if (!request.auth) {
		throw new HttpsError('unauthenticated', 'User must be logged in');
	}

	// Initialize Stripe with secret
	const stripe = require('stripe')(stripeSecret.value());

	const userId = request.auth.uid;

	try {
		// Get user's Stripe account ID from Firestore
		const userDoc = await admin.firestore().collection('users').doc(userId).get();
		const stripeAccountId = userDoc.data()?.stripeAccountId;

		if (!stripeAccountId) {
			return {onboardingComplete: false};
		}

		// Retrieve account details from Stripe
		const account = await stripe.accounts.retrieve(stripeAccountId);

		// Check if charges are enabled (indicates completed onboarding)
		const onboardingComplete = account.charges_enabled && account.payouts_enabled;

		// Update Firestore
		await admin.firestore().collection('users').doc(userId).update({
			stripeOnboardingComplete: onboardingComplete,
		});

		return {
			onboardingComplete: onboardingComplete,
			accountId: stripeAccountId,
		};
	} catch (error) {
		console.error('Error checking account status:', error);
		throw new HttpsError('internal', error.message);
	}
});

/**
 * Create a Payment Intent
 * Called when buyer accepts an offer and is ready to pay
 */
exports.createPaymentIntent = onCall({secrets: [stripeSecret]}, async (request) => {
	if (!request.auth) {
		throw new HttpsError('unauthenticated', 'User must be logged in');
	}

	// Initialize Stripe with secret
	const stripe = require('stripe')(stripeSecret.value());

	const {
		amount, // Total amount in dollars (e.g., 10.50)
		platformFee, // Your fee in dollars (e.g., 1.00)
		sellerStripeAccountId,
		transactionId, // For metadata tracking
	} = request.data;

	// Validate inputs
	if (!amount || !platformFee || !sellerStripeAccountId) {
		throw new HttpsError(
			'invalid-argument',
			'Missing required payment parameters'
		);
	}

	// Convert to cents (Stripe uses smallest currency unit)
	const amountCents = Math.round(amount * 100);
	const feeCents = Math.round(platformFee * 100);

	try {
		// Verify seller's connected account is active
		const account = await stripe.accounts.retrieve(sellerStripeAccountId);
		if (!account.charges_enabled) {
			throw new HttpsError(
				'failed-precondition',
				'Seller has not completed payment setup'
			);
		}

		// Create payment intent
		const paymentIntent = await stripe.paymentIntents.create({
			amount: amountCents,
			currency: 'usd',
			application_fee_amount: feeCents, // Your platform fee
			transfer_data: {
				destination: sellerStripeAccountId, // Seller receives the rest
			},
			metadata: {
				transactionId: transactionId || '',
				platform: 'flour',
			},
			description: `Flour transaction ${transactionId}`,
		});

		return {
			clientSecret: paymentIntent.client_secret,
			paymentIntentId: paymentIntent.id,
		};
	} catch (error) {
		console.error('Error creating payment intent:', error);
		throw new HttpsError('internal', error.message);
	}
});

/**
 * Webhook handler for Stripe events
 * Called by Stripe when payment events occur (success, failure, refund, etc.)
 */
exports.stripeWebhook = onRequest({secrets: [stripeSecret]}, async (req, res) => {
	// Initialize Stripe with secret
	const stripe = require('stripe')(stripeSecret.value());

	// Verify webhook signature to ensure it's from Stripe
	const sig = req.headers['stripe-signature'];
	const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;

	let event;

	try {
		event = stripe.webhooks.constructEvent(req.rawBody, sig, webhookSecret);
	} catch (err) {
		console.error('Webhook signature verification failed:', err.message);
		return res.status(400).send(`Webhook Error: ${err.message}`);
	}

	// Handle the event
	switch (event.type) {
	case 'payment_intent.succeeded':
		const paymentIntent = event.data.object;
		console.log(`Payment succeeded: ${paymentIntent.id}`);

		// Update transaction status in Firestore
		const transactionId = paymentIntent.metadata.transactionId;
		if (transactionId) {
			await admin.firestore().collection('transactions').doc(transactionId).update({
				paymentStatus: 'succeeded',
				paymentIntentId: paymentIntent.id,
				paidAt: admin.firestore.FieldValue.serverTimestamp(),
			});
		}
		break;

	case 'payment_intent.payment_failed':
		const failedIntent = event.data.object;
		console.log(`Payment failed: ${failedIntent.id}`);

		const failedTransactionId = failedIntent.metadata.transactionId;
		if (failedTransactionId) {
			await admin.firestore().collection('transactions').doc(failedTransactionId).update({
				paymentStatus: 'failed',
				paymentError: failedIntent.last_payment_error?.message || 'Unknown error',
			});
		}
		break;

	case 'account.updated':
		// Connected account was updated (e.g., completed onboarding)
		const account = event.data.object;
		console.log(`Account updated: ${account.id}`);
		break;

	default:
		console.log(`Unhandled event type: ${event.type}`);
	}

	// Return 200 to acknowledge receipt
	res.json({received: true});
});
