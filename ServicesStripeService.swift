import Foundation
import FirebaseFunctions
import Observation

/// Service for handling Stripe payments and seller onboarding
@Observable
class StripeService {
	var isProcessing = false
	var errorMessage: String?

	private var functions: Functions {
		let functions = Functions.functions()

		// Use local emulator in debug builds
		// Start emulator with: firebase emulators:start
		#if DEBUG
		functions.useEmulator(withHost: "localhost", port: 5001)
		#endif

		return functions
	}

	/// Create a Stripe Connected Account for a seller
	/// Returns the onboarding URL to open in Safari/WebView
	func createConnectedAccount(email: String) async throws -> (accountId: String, onboardingURL: URL) {
		isProcessing = true
		errorMessage = nil

		defer { isProcessing = false }

		do {
			let result = try await functions.httpsCallable("createConnectedAccount").call([
				"email": email
			])

			guard let data = result.data as? [String: Any],
				  let accountId = data["accountId"] as? String,
				  let urlString = data["accountLinkUrl"] as? String,
				  let url = URL(string: urlString) else {
				throw StripeError.invalidResponse
			}

			return (accountId, url)
		} catch {
			errorMessage = error.localizedDescription
			throw error
		}
	}

	/// Check if seller has completed Stripe onboarding
	func checkAccountStatus() async throws -> Bool {
		isProcessing = true
		errorMessage = nil

		defer { isProcessing = false }

		do {
			let result = try await functions.httpsCallable("checkAccountStatus").call()

			guard let data = result.data as? [String: Any],
				  let isComplete = data["onboardingComplete"] as? Bool else {
				throw StripeError.invalidResponse
			}

			return isComplete
		} catch {
			errorMessage = error.localizedDescription
			throw error
		}
	}

	/// Create a payment intent for a transaction
	/// Returns the client secret needed by Stripe SDK to collect payment
	func createPaymentIntent(
		amount: Double,
		platformFee: Double,
		sellerStripeAccountId: String,
		transactionId: String
	) async throws -> String {
		isProcessing = true
		errorMessage = nil

		defer { isProcessing = false }

		do {
			let result = try await functions.httpsCallable("createPaymentIntent").call([
				"amount": amount,
				"platformFee": platformFee,
				"sellerStripeAccountId": sellerStripeAccountId,
				"transactionId": transactionId
			])

			guard let data = result.data as? [String: Any],
				  let clientSecret = data["clientSecret"] as? String else {
				throw StripeError.invalidResponse
			}

			return clientSecret
		} catch {
			errorMessage = error.localizedDescription
			throw error
		}
	}
}

enum StripeError: LocalizedError {
	case invalidResponse
	case onboardingIncomplete
	case paymentFailed(String)

	var errorDescription: String? {
		switch self {
		case .invalidResponse:
			return "Invalid response from payment server"
		case .onboardingIncomplete:
			return "Please complete payment setup first"
		case .paymentFailed(let reason):
			return "Payment failed: \(reason)"
		}
	}
}
