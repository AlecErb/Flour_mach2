//
//  FirestoreService.swift
//  Flour
//
//  Handles all Firestore database operations
//

import Foundation
import FirebaseFirestore
import Observation

@Observable
class FirestoreService {
	private let db = Firestore.firestore()

	var isLoading = false
	var errorMessage: String?

	// MARK: - Users

	func saveUser(_ user: User) async throws {
		let data: [String: Any] = [
			"displayName": user.displayName,
			"email": user.email,
			"phone": user.phone,
			"schoolId": user.schoolId,
			"createdAt": Timestamp(date: user.createdAt),
			"rating": user.rating as Any,
			"totalTransactions": user.totalTransactions,
			"stripeAccountId": user.stripeAccountId as Any,
			"stripeOnboardingComplete": user.stripeOnboardingComplete as Any
		]

		try await db.collection("users").document(user.id).setData(data, merge: true)
	}

	func loadUser(id: String) async throws -> User? {
		let doc = try await db.collection("users").document(id).getDocument()
		guard doc.exists, let data = doc.data() else { return nil }

		return User(
			id: doc.documentID,
			displayName: data["displayName"] as? String ?? "",
			email: data["email"] as? String ?? "",
			phone: data["phone"] as? String ?? "",
			schoolId: data["schoolId"] as? String ?? "",
			createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
			rating: data["rating"] as? Double,
			totalTransactions: data["totalTransactions"] as? Int ?? 0,
			stripeAccountId: data["stripeAccountId"] as? String,
			stripeOnboardingComplete: data["stripeOnboardingComplete"] as? Bool
		)
	}

	// MARK: - Requests

	func saveRequest(_ request: Request) async throws {
		let data: [String: Any] = [
			"requesterId": request.requesterId,
			"itemDescription": request.itemDescription,
			"offerPrice": request.offerPrice,
			"urgency": request.urgency.rawValue,
			"radiusMeters": request.radiusMeters,
			"location": [
				"latitude": request.location.latitude,
				"longitude": request.location.longitude
			],
			"status": request.status.rawValue,
			"fulfillerId": request.fulfillerId as Any,
			"createdAt": Timestamp(date: request.createdAt),
			"expiresAt": Timestamp(date: request.expiresAt)
		]

		try await db.collection("requests").document(request.id).setData(data, merge: true)
	}

	func loadRequests() async throws -> [Request] {
		let snapshot = try await db.collection("requests")
			.order(by: "createdAt", descending: true)
			.limit(to: 100)
			.getDocuments()

		return snapshot.documents.compactMap { doc -> Request? in
			guard let data = doc.data(),
				  let requesterId = data["requesterId"] as? String,
				  let itemDescription = data["itemDescription"] as? String,
				  let offerPrice = data["offerPrice"] as? Double,
				  let urgencyRaw = data["urgency"] as? String,
				  let urgency = Urgency(rawValue: urgencyRaw),
				  let radiusMeters = data["radiusMeters"] as? Double,
				  let locationData = data["location"] as? [String: Double],
				  let lat = locationData["latitude"],
				  let lon = locationData["longitude"],
				  let statusRaw = data["status"] as? String,
				  let status = RequestStatus(rawValue: statusRaw),
				  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue(),
				  let expiresAt = (data["expiresAt"] as? Timestamp)?.dateValue() else {
				return nil
			}

			return Request(
				id: doc.documentID,
				requesterId: requesterId,
				itemDescription: itemDescription,
				offerPrice: offerPrice,
				urgency: urgency,
				radiusMeters: radiusMeters,
				location: LocationCoordinate(latitude: lat, longitude: lon),
				status: status,
				fulfillerId: data["fulfillerId"] as? String,
				createdAt: createdAt,
				expiresAt: expiresAt
			)
		}
	}

	// MARK: - Offers

	func saveOffer(_ offer: Offer) async throws {
		let data: [String: Any] = [
			"requestId": offer.requestId,
			"userId": offer.userId,
			"amount": offer.amount,
			"status": offer.status.rawValue,
			"isCounterOffer": offer.isCounterOffer,
			"parentOfferId": offer.parentOfferId as Any,
			"createdAt": Timestamp(date: offer.createdAt)
		]

		try await db.collection("offers").document(offer.id).setData(data, merge: true)
	}

	func loadOffers(forRequest requestId: String) async throws -> [Offer] {
		let snapshot = try await db.collection("offers")
			.whereField("requestId", isEqualTo: requestId)
			.order(by: "createdAt", descending: false)
			.getDocuments()

		return snapshot.documents.compactMap { doc -> Request? in
			guard let data = doc.data(),
				  let requestId = data["requestId"] as? String,
				  let userId = data["userId"] as? String,
				  let amount = data["amount"] as? Double,
				  let statusRaw = data["status"] as? String,
				  let status = OfferStatus(rawValue: statusRaw),
				  let isCounterOffer = data["isCounterOffer"] as? Bool,
				  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() else {
				return nil
			}

			return Offer(
				id: doc.documentID,
				requestId: requestId,
				userId: userId,
				amount: amount,
				status: status,
				parentOfferId: data["parentOfferId"] as? String,
				createdAt: createdAt
			)
		}
	}

	// MARK: - Transactions

	func saveTransaction(_ transaction: Transaction) async throws {
		let data: [String: Any] = [
			"requestId": transaction.requestId,
			"requesterId": transaction.requesterId,
			"fulfillerId": transaction.fulfillerId,
			"itemPrice": transaction.itemPrice,
			"platformFee": transaction.platformFee,
			"totalCharged": transaction.totalCharged,
			"status": transaction.status.rawValue,
			"requesterConfirmed": transaction.requesterConfirmed,
			"fulfillerConfirmed": transaction.fulfillerConfirmed,
			"createdAt": Timestamp(date: transaction.createdAt),
			"completedAt": transaction.completedAt.map { Timestamp(date: $0) } as Any,
			"paymentStatus": transaction.paymentStatus as Any,
			"paidAt": transaction.paidAt.map { Timestamp(date: $0) } as Any
		]

		try await db.collection("transactions").document(transaction.id).setData(data, merge: true)
	}

	func loadTransactions(forUser userId: String) async throws -> [Transaction] {
		// Query transactions where user is requester OR fulfiller
		let asRequester = db.collection("transactions")
			.whereField("requesterId", isEqualTo: userId)
		let asFulfiller = db.collection("transactions")
			.whereField("fulfillerId", isEqualTo: userId)

		// Execute both queries
		async let requesterDocs = asRequester.getDocuments()
		async let fulfillerDocs = asFulfiller.getDocuments()

		let (rDocs, fDocs) = try await (requesterDocs, fulfillerDocs)

		// Combine and deduplicate
		var allDocs = rDocs.documents
		for doc in fDocs.documents {
			if !allDocs.contains(where: { $0.documentID == doc.documentID }) {
				allDocs.append(doc)
			}
		}

		return allDocs.compactMap { doc -> Transaction? in
			guard let data = doc.data(),
				  let requestId = data["requestId"] as? String,
				  let requesterId = data["requesterId"] as? String,
				  let fulfillerId = data["fulfillerId"] as? String,
				  let itemPrice = data["itemPrice"] as? Double,
				  let platformFee = data["platformFee"] as? Double,
				  let statusRaw = data["status"] as? String,
				  let status = TransactionStatus(rawValue: statusRaw),
				  let requesterConfirmed = data["requesterConfirmed"] as? Bool,
				  let fulfillerConfirmed = data["fulfillerConfirmed"] as? Bool,
				  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() else {
				return nil
			}

			return Transaction(
				id: doc.documentID,
				requestId: requestId,
				requesterId: requesterId,
				fulfillerId: fulfillerId,
				itemPrice: itemPrice,
				platformFee: platformFee,
				status: status,
				requesterConfirmed: requesterConfirmed,
				fulfillerConfirmed: fulfillerConfirmed,
				createdAt: createdAt,
				completedAt: (data["completedAt"] as? Timestamp)?.dateValue(),
				paymentStatus: data["paymentStatus"] as? String,
				paidAt: (data["paidAt"] as? Timestamp)?.dateValue()
			)
		}
	}

	// MARK: - Messages

	func saveMessage(_ message: Message) async throws {
		let data: [String: Any] = [
			"transactionId": message.transactionId,
			"senderId": message.senderId,
			"content": message.content,
			"isRead": message.isRead,
			"createdAt": Timestamp(date: message.createdAt)
		]

		try await db.collection("messages").document(message.id).setData(data, merge: true)
	}

	func loadMessages(forTransaction transactionId: String) async throws -> [Message] {
		let snapshot = try await db.collection("messages")
			.whereField("transactionId", isEqualTo: transactionId)
			.order(by: "createdAt", descending: false)
			.getDocuments()

		return snapshot.documents.compactMap { doc -> Request? in
			guard let data = doc.data(),
				  let transactionId = data["transactionId"] as? String,
				  let senderId = data["senderId"] as? String,
				  let content = data["content"] as? String,
				  let isRead = data["isRead"] as? Bool,
				  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() else {
				return nil
			}

			return Message(
				id: doc.documentID,
				transactionId: transactionId,
				senderId: senderId,
				content: content,
				createdAt: createdAt,
				isRead: isRead
			)
		}
	}

	// MARK: - Real-time Listeners

	func listenToMessages(forTransaction transactionId: String, onChange: @escaping ([Message]) -> Void) -> ListenerRegistration {
		return db.collection("messages")
			.whereField("transactionId", isEqualTo: transactionId)
			.order(by: "createdAt", descending: false)
			.addSnapshotListener { snapshot, error in
				guard let documents = snapshot?.documents else { return }

				let messages = documents.compactMap { doc -> Message? in
					guard let data = doc.data(),
						  let transactionId = data["transactionId"] as? String,
						  let senderId = data["senderId"] as? String,
						  let content = data["content"] as? String,
						  let isRead = data["isRead"] as? Bool,
						  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() else {
						return nil
					}

					return Message(
						id: doc.documentID,
						transactionId: transactionId,
						senderId: senderId,
						content: content,
						createdAt: createdAt,
						isRead: isRead
					)
				}

				onChange(messages)
			}
	}
}
