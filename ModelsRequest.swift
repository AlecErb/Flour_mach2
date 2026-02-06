//
//  Request.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation
import CoreLocation

/// Urgency level for a request
enum Urgency: String, Codable, CaseIterable {
    case asap = "ASAP"
    case thirtyMinutes = "30 min"
    case oneHour = "1 hour"
    case flexible = "Flexible"
    
    var displayName: String {
        return self.rawValue
    }
    
    var sortOrder: Int {
        switch self {
        case .asap: return 0
        case .thirtyMinutes: return 1
        case .oneHour: return 2
        case .flexible: return 3
        }
    }
}

/// Status of a request
enum RequestStatus: String, Codable {
    case open = "open"
    case negotiating = "negotiating"
    case matched = "matched"
    case completed = "completed"
    case cancelled = "cancelled"
    case expired = "expired"
}

/// Represents a request for an item
struct Request: Identifiable, Codable, Hashable {
    let id: String
    let requesterId: String
    var itemDescription: String
    var offerPrice: Double
    var urgency: Urgency
    var radiusMeters: Double
    var location: LocationCoordinate
    var status: RequestStatus
    var fulfillerId: String?
    let createdAt: Date
    var expiresAt: Date
    var durationHours: Double
    
    // Computed properties
    var isExpired: Bool {
        return Date() > expiresAt
    }
    
    var isActive: Bool {
        return status == .open || status == .negotiating
    }
    
    var hasMatch: Bool {
        return fulfillerId != nil && status == .matched
    }
    
    var timeRemaining: TimeInterval {
        return expiresAt.timeIntervalSince(Date())
    }
    
    var formattedTimeRemaining: String {
        let remaining = timeRemaining
        if remaining <= 0 {
            return "Expired"
        }
        
        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var formattedPrice: String {
        return String(format: "$%.2f", offerPrice)
    }
    
    init(
        id: String = UUID().uuidString,
        requesterId: String,
        itemDescription: String,
        offerPrice: Double,
        urgency: Urgency,
        radiusMeters: Double,
        location: LocationCoordinate,
        status: RequestStatus = .open,
        fulfillerId: String? = nil,
        createdAt: Date = Date(),
        durationHours: Double = 2.0
    ) {
        self.id = id
        self.requesterId = requesterId
        self.itemDescription = itemDescription
        self.offerPrice = offerPrice
        self.urgency = urgency
        self.radiusMeters = radiusMeters
        self.location = location
        self.status = status
        self.fulfillerId = fulfillerId
        self.createdAt = createdAt
        self.durationHours = durationHours
        self.expiresAt = createdAt.addingTimeInterval(durationHours * 3600)
    }
}

// MARK: - Location Coordinate

/// A codable wrapper for CLLocationCoordinate2D
struct LocationCoordinate: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    var clLocationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Extensions

extension Request {
    /// Calculate distance from a given location
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let requestLocation = CLLocation(
            latitude: location.latitude,
            longitude: location.longitude
        )
        let fromLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        return fromLocation.distance(from: requestLocation)
    }
    
    /// Check if a coordinate is within the request's radius
    func isWithinRadius(of coordinate: CLLocationCoordinate2D) -> Bool {
        return distance(from: coordinate) <= radiusMeters
    }
    
    /// Formatted distance string
    func formattedDistance(from coordinate: CLLocationCoordinate2D) -> String {
        let distanceInMeters = distance(from: coordinate)
        
        if distanceInMeters < 1000 {
            return String(format: "%.0f m", distanceInMeters)
        } else {
            let distanceInKm = distanceInMeters / 1000
            return String(format: "%.1f km", distanceInKm)
        }
    }
}
