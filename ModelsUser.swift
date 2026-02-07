//
//  User.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation

/// Represents a user in the Flour app
struct User: Identifiable, Codable, Hashable {
    let id: String
    var displayName: String
    var email: String
    var phone: String
    var schoolId: String
    var createdAt: Date
    var rating: Double?
    var totalTransactions: Int

    // Stripe payment fields (for sellers)
    var stripeAccountId: String?
    var stripeOnboardingComplete: Bool?

    // Computed property for formatted rating
    var formattedRating: String {
        guard let rating = rating else { return "No rating" }
        return String(format: "%.1f", rating)
    }
    
    // Validation
    var isValid: Bool {
        return !displayName.isEmpty &&
               email.contains("@") &&
               !phone.isEmpty
    }
    
    init(
        id: String = UUID().uuidString,
        displayName: String,
        email: String,
        phone: String,
        schoolId: String,
        createdAt: Date = Date(),
        rating: Double? = nil,
        totalTransactions: Int = 0,
        stripeAccountId: String? = nil,
        stripeOnboardingComplete: Bool? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.phone = phone
        self.schoolId = schoolId
        self.createdAt = createdAt
        self.rating = rating
        self.totalTransactions = totalTransactions
        self.stripeAccountId = stripeAccountId
        self.stripeOnboardingComplete = stripeOnboardingComplete
    }
}

// MARK: - Extensions

extension User {
    /// Check if email is valid
    var hasValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Get initials from display name
    var initials: String {
        let components = displayName.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
}
