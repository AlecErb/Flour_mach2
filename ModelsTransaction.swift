//
//  Transaction.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation

/// Status of a transaction
enum TransactionStatus: String, Codable {
    case pending = "pending"
    case completed = "completed"
    case disputed = "disputed"
    case refunded = "refunded"
}

/// Represents a transaction between requester and fulfiller
struct Transaction: Identifiable, Codable, Hashable {
    let id: String
    let requestId: String
    let requesterId: String
    let fulfillerId: String
    var itemPrice: Double
    var platformFee: Double
    var totalCharged: Double
    var status: TransactionStatus
    var requesterConfirmed: Bool
    var fulfillerConfirmed: Bool
    let createdAt: Date
    var completedAt: Date?
    
    // Computed properties
    var isCompleted: Bool {
        return status == .completed
    }
    
    var isPending: Bool {
        return status == .pending
    }
    
    var bothConfirmed: Bool {
        return requesterConfirmed && fulfillerConfirmed
    }
    
    var formattedItemPrice: String {
        return String(format: "$%.2f", itemPrice)
    }
    
    var formattedPlatformFee: String {
        return String(format: "$%.2f", platformFee)
    }
    
    var formattedTotal: String {
        return String(format: "$%.2f", totalCharged)
    }
    
    init(
        id: String = UUID().uuidString,
        requestId: String,
        requesterId: String,
        fulfillerId: String,
        itemPrice: Double,
        platformFee: Double? = nil,
        status: TransactionStatus = .pending,
        requesterConfirmed: Bool = false,
        fulfillerConfirmed: Bool = false,
        createdAt: Date = Date(),
        completedAt: Date? = nil
    ) {
        self.id = id
        self.requestId = requestId
        self.requesterId = requesterId
        self.fulfillerId = fulfillerId
        self.itemPrice = itemPrice
        
        // Calculate platform fee if not provided
        let calculatedFee = platformFee ?? Transaction.calculatePlatformFee(for: itemPrice)
        self.platformFee = calculatedFee
        self.totalCharged = itemPrice + calculatedFee
        
        self.status = status
        self.requesterConfirmed = requesterConfirmed
        self.fulfillerConfirmed = fulfillerConfirmed
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}

// MARK: - Platform Fee Calculation

extension Transaction {
    /// Calculate platform fee (10% capped at $2)
    static func calculatePlatformFee(for itemPrice: Double) -> Double {
        let fee = itemPrice * 0.10
        return min(fee, 2.00)
    }
    
    /// Calculate total amount buyer will pay
    static func calculateTotal(for itemPrice: Double) -> Double {
        return itemPrice + calculatePlatformFee(for: itemPrice)
    }
    
    /// Get fee breakdown for display
    var feeBreakdown: String {
        return """
        Item Price: \(formattedItemPrice)
        Platform Fee: \(formattedPlatformFee)
        Total: \(formattedTotal)
        """
    }
}

// MARK: - Confirmation Logic

extension Transaction {
    /// Mark as confirmed by a user
    mutating func confirm(byUser userId: String) {
        if userId == requesterId {
            requesterConfirmed = true
        } else if userId == fulfillerId {
            fulfillerConfirmed = true
        }
        
        // If both confirmed, mark as completed
        if bothConfirmed {
            status = .completed
            completedAt = Date()
        }
    }
}
