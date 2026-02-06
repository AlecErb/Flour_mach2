//
//  Offer.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation

/// Status of an offer during negotiation
enum OfferStatus: String, Codable {
    case pending = "pending"
    case accepted = "accepted"
    case declined = "declined"
    case countered = "countered"
}

/// Represents an offer or counter-offer in the negotiation process
struct Offer: Identifiable, Codable, Hashable {
    let id: String
    let requestId: String
    let userId: String // User making the offer (could be requester or fulfiller)
    var amount: Double
    var status: OfferStatus
    let parentOfferId: String? // For tracking counter-offers
    let createdAt: Date
    
    var formattedAmount: String {
        return String(format: "$%.2f", amount)
    }
    
    var isPending: Bool {
        return status == .pending
    }
    
    var isAccepted: Bool {
        return status == .accepted
    }
    
    var isCounterOffer: Bool {
        return parentOfferId != nil
    }
    
    init(
        id: String = UUID().uuidString,
        requestId: String,
        userId: String,
        amount: Double,
        status: OfferStatus = .pending,
        parentOfferId: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.requestId = requestId
        self.userId = userId
        self.amount = amount
        self.status = status
        self.parentOfferId = parentOfferId
        self.createdAt = createdAt
    }
}

// MARK: - Extensions

extension Offer {
    /// Create a counter-offer based on this offer
    func createCounterOffer(byUser userId: String, withAmount amount: Double) -> Offer {
        return Offer(
            requestId: requestId,
            userId: userId,
            amount: amount,
            status: .pending,
            parentOfferId: self.id
        )
    }
}
