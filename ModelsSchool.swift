//
//  School.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation

/// Represents a school/university in the Flour app
struct School: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var domain: String // e.g., "stanford.edu"
    var isActive: Bool
    
    init(
        id: String = UUID().uuidString,
        name: String,
        domain: String,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.domain = domain
        self.isActive = isActive
    }
}

// MARK: - Extensions

extension School {
    /// Check if an email belongs to this school
    func matches(email: String) -> Bool {
        return email.lowercased().hasSuffix("@\(domain.lowercased())")
    }
}
