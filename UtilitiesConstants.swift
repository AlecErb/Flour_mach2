//
//  Constants.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation
import CoreLocation

enum Constants {
    // MARK: - App Info
    enum App {
        static let name = "Flour"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }
    
    // MARK: - URLs
    enum URLs {
        static let termsOfService = "https://flour.app/terms"
        static let privacyPolicy = "https://flour.app/privacy"
        static let support = "https://flour.app/support"
    }
    
    // MARK: - Request Configuration
    enum Request {
        static let defaultDurationHours: Double = 2
        static let minDurationHours: Double = 0.5
        static let maxDurationHours: Double = 24
        
        static let defaultRadiusMeters: CLLocationDistance = 800 // ~10 min walk
        static let minRadiusMeters: CLLocationDistance = 100
        static let maxRadiusMeters: CLLocationDistance = 1600 // ~20 min walk
        
        static let minPrice: Double = 1.0
        static let maxPrice: Double = 100.0
    }
    
    // MARK: - Payment Configuration
    enum Payment {
        static let platformFeePercentage: Double = 0.10 // 10%
        static let platformFeeCap: Double = 2.00 // $2 max
        
        static func calculatePlatformFee(for itemPrice: Double) -> Double {
            let fee = itemPrice * platformFeePercentage
            return min(fee, platformFeeCap)
        }
        
        static func calculateTotal(itemPrice: Double) -> Double {
            return itemPrice + calculatePlatformFee(for: itemPrice)
        }
    }
    
    // MARK: - Validation
    enum Validation {
        static let minDisplayNameLength = 2
        static let maxDisplayNameLength = 30
        static let maxItemDescriptionLength = 200
        static let maxMessageLength = 500
        static let eduEmailDomains = [".edu"] // Can be expanded
    }
    
    // MARK: - UI Constants
    enum UI {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        
        static let buttonHeight: CGFloat = 50
        static let inputHeight: CGFloat = 44
    }
    
    // MARK: - Animation
    enum Animation {
        static let standard = 0.3
        static let quick = 0.15
        static let slow = 0.5
    }
}
