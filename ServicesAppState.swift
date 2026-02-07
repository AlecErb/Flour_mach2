//
//  AppState.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation
import FirebaseAuth
import Observation

@Observable
class AppState {
	// MARK: - Auth State
	var currentUser: User?
	var isLoggedIn: Bool { currentUser != nil }
	var authIsLoading = false
	var authError: String?

	private let authService = AuthService()
	private let stripeService = StripeService()

	// MARK: - Data
	var schools: [School] = MockData.schools
	var users: [User] = MockData.users
	var requests: [Request] = MockData.requests
	var offers: [Offer] = MockData.offers
	var transactions: [Transaction] = MockData.transactions
	var messages: [Message] = MockData.messages

	init() {
		// Restore Firebase session from previous launch
		if let firebaseUser = authService.firebaseUser {
			currentUser = User(
				id: firebaseUser.uid,
				displayName: firebaseUser.displayName ?? "User",
				email: firebaseUser.email ?? "",
				phone: "",
				schoolId: ""
			)
		}
	}

	// MARK: - Firebase Auth Methods

	func signUp(email: String, password: String, displayName: String, phone: String, schoolId: String) async {
		authIsLoading = true
		authError = nil
		defer { authIsLoading = false }

		do {
			try await authService.signUp(email: email, password: password, displayName: displayName)
			let user = User(
				id: authService.firebaseUser?.uid ?? UUID().uuidString,
				displayName: displayName,
				email: email,
				phone: phone,
				schoolId: schoolId
			)
			users.append(user)
			currentUser = user
		} catch {
			authError = error.localizedDescription
		}
	}

	func signIn(email: String, password: String) async throws {
		authIsLoading = true
		authError = nil
		defer { authIsLoading = false }

		do {
			try await authService.signIn(email: email, password: password)
			let firebaseUser = authService.firebaseUser
			currentUser = User(
				id: firebaseUser?.uid ?? UUID().uuidString,
				displayName: firebaseUser?.displayName ?? "User",
				email: firebaseUser?.email ?? email,
				phone: "",
				schoolId: ""
			)
		} catch {
			authError = error.localizedDescription
			throw error
		}
	}

	func loginAsDemo() {
		currentUser = MockData.currentUser
	}

	func logout() {
		authService.signOut()
		currentUser = nil
	}

	// MARK: - School Lookup

	func school(forEmail email: String) -> School? {
		schools.first { $0.matches(email: email) }
	}

	func school(withId id: String) -> School? {
		schools.first { $0.id == id }
	}

	func user(withId id: String) -> User? {
		users.first { $0.id == id }
	}

	// MARK: - Request Methods

	var activeRequests: [Request] {
		requests.filter { $0.isActive }
	}

	func myRequests(userId: String) -> [Request] {
		requests.filter { $0.requesterId == userId }
	}

	func createRequest(
		itemDescription: String,
		offerPrice: Double,
		urgency: Urgency,
		radiusMeters: Double,
		location: LocationCoordinate,
		durationHours: Double = Constants.Request.defaultDurationHours
	) {
		guard let user = currentUser else { return }
		let request = Request(
			requesterId: user.id,
			itemDescription: itemDescription,
			offerPrice: offerPrice,
			urgency: urgency,
			radiusMeters: radiusMeters,
			location: location,
			durationHours: durationHours
		)
		requests.insert(request, at: 0)
	}

	func cancelRequest(_ requestId: String) {
		guard let idx = requests.firstIndex(where: { $0.id == requestId }) else { return }
		requests[idx].status = .cancelled
	}

	// MARK: - Offer Methods

	func offersForRequest(_ requestId: String) -> [Offer] {
		offers.filter { $0.requestId == requestId }
	}

	func makeOffer(requestId: String, amount: Double) {
		guard let user = currentUser else { return }
		let offer = Offer(
			requestId: requestId,
			userId: user.id,
			amount: amount
		)
		offers.append(offer)

		if let idx = requests.firstIndex(where: { $0.id == requestId }) {
			requests[idx].status = .negotiating
		}
	}

	func acceptOffer(_ offerId: String) {
		guard let offerIdx = offers.firstIndex(where: { $0.id == offerId }) else { return }
		offers[offerIdx].status = .accepted

		let offer = offers[offerIdx]

		guard let reqIdx = requests.firstIndex(where: { $0.id == offer.requestId }) else { return }
		requests[reqIdx].status = .matched
		requests[reqIdx].fulfillerId = offer.userId

		let transaction = Transaction(
			requestId: offer.requestId,
			requesterId: requests[reqIdx].requesterId,
			fulfillerId: offer.userId,
			itemPrice: offer.amount
		)
		transactions.append(transaction)
	}

	func declineOffer(_ offerId: String) {
		guard let idx = offers.firstIndex(where: { $0.id == offerId }) else { return }
		offers[idx].status = .declined
	}

	func counterOffer(_ offerId: String, newAmount: Double) {
		guard let idx = offers.firstIndex(where: { $0.id == offerId }) else { return }
		guard let user = currentUser else { return }
		offers[idx].status = .countered

		let counter = offers[idx].createCounterOffer(byUser: user.id, withAmount: newAmount)
		offers.append(counter)
	}

	// MARK: - Transaction Methods

	func myTransactions(userId: String) -> [Transaction] {
		transactions.filter { $0.requesterId == userId || $0.fulfillerId == userId }
	}

	func transaction(forRequestId requestId: String) -> Transaction? {
		transactions.first { $0.requestId == requestId }
	}

	func confirmTransaction(_ transactionId: String) {
		guard let user = currentUser else { return }
		guard let idx = transactions.firstIndex(where: { $0.id == transactionId }) else { return }
		transactions[idx].confirm(byUser: user.id)

		if transactions[idx].bothConfirmed {
			if let reqIdx = requests.firstIndex(where: { $0.id == transactions[idx].requestId }) {
				requests[reqIdx].status = .completed
			}
		}
	}

	// MARK: - Message Methods

	func messages(forTransaction transactionId: String) -> [Message] {
		messages.filter { $0.transactionId == transactionId }
			.sorted { $0.createdAt < $1.createdAt }
	}

	func sendMessage(transactionId: String, content: String) {
		guard let user = currentUser else { return }
		let message = Message(
			transactionId: transactionId,
			senderId: user.id,
			content: content
		)
		messages.append(message)
	}

	func markMessagesRead(transactionId: String) {
		guard let user = currentUser else { return }
		for i in messages.indices {
			if messages[i].transactionId == transactionId &&
				messages[i].senderId != user.id &&
				!messages[i].isRead {
				messages[i].isRead = true
			}
		}
	}

	func unreadCount(forTransaction transactionId: String) -> Int {
		guard let user = currentUser else { return 0 }
		return messages.filter {
			$0.transactionId == transactionId &&
			$0.senderId != user.id &&
			!$0.isRead
		}.count
	}

	func activeTransactionsWithMessages() -> [(Transaction, Message?)] {
		guard let user = currentUser else { return [] }
		let myTxns = transactions.filter {
			($0.requesterId == user.id || $0.fulfillerId == user.id) && $0.isPending
		}
		return myTxns.map { txn in
			let lastMsg = messages(forTransaction: txn.id).last
			return (txn, lastMsg)
		}.sorted { a, b in
			let aDate = a.1?.createdAt ?? a.0.createdAt
			let bDate = b.1?.createdAt ?? b.0.createdAt
			return aDate > bDate
		}
	}

	// MARK: - Stripe Payment Methods

	/// Set up seller account - creates Stripe Connected Account and returns onboarding URL
	func setupSellerAccount() async throws -> URL {
		guard let user = currentUser else {
			throw StripeError.invalidResponse
		}

		let (accountId, onboardingURL) = try await stripeService.createConnectedAccount(email: user.email)

		// Update user with Stripe account ID (in real app, save to Firestore)
		if let idx = users.firstIndex(where: { $0.id == user.id }) {
			users[idx].stripeAccountId = accountId
			users[idx].stripeOnboardingComplete = false
		}

		return onboardingURL
	}

	/// Check if current user has completed Stripe onboarding
	func checkSellerStatus() async throws -> Bool {
		let isComplete = try await stripeService.checkAccountStatus()

		// Update user (in real app, Firestore updates via Cloud Function)
		if let user = currentUser,
		   let idx = users.firstIndex(where: { $0.id == user.id }) {
			users[idx].stripeOnboardingComplete = isComplete
		}

		return isComplete
	}

	/// Process payment for a transaction
	/// Returns client secret for Stripe Payment Sheet
	func createPayment(for transactionId: String) async throws -> String {
		guard let txnIdx = transactions.firstIndex(where: { $0.id == transactionId }) else {
			throw StripeError.invalidResponse
		}

		let transaction = transactions[txnIdx]

		// Get seller's Stripe account ID
		guard let seller = users.first(where: { $0.id == transaction.fulfillerId }),
			  let sellerStripeId = seller.stripeAccountId,
			  seller.stripeOnboardingComplete == true else {
			throw StripeError.onboardingIncomplete
		}

		// Create payment intent
		let clientSecret = try await stripeService.createPaymentIntent(
			amount: transaction.totalAmount,
			platformFee: transaction.platformFee,
			sellerStripeAccountId: sellerStripeId,
			transactionId: transaction.id
		)

		// Update transaction status to processing
		transactions[txnIdx].paymentStatus = "processing"

		return clientSecret
	}

	/// Mark payment as succeeded (called after Stripe confirms)
	func markPaymentSucceeded(transactionId: String) {
		guard let idx = transactions.firstIndex(where: { $0.id == transactionId }) else { return }
		transactions[idx].paymentStatus = "succeeded"
		transactions[idx].paidAt = Date()
	}

	/// Mark payment as failed
	func markPaymentFailed(transactionId: String, error: String) {
		guard let idx = transactions.firstIndex(where: { $0.id == transactionId }) else { return }
		transactions[idx].paymentStatus = "failed"
	}
}
