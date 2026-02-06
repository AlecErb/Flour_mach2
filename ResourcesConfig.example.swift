//
//  Config.example.swift
//  Flour
//
//  Created on 2026-02-06.
//
//  Copy this file to Config.swift and add your actual API keys.
//  Config.swift is gitignored to protect your secrets.

import Foundation

enum Config {
    // MARK: - Environment
    enum Environment {
        case development
        case staging
        case production
        
        static var current: Environment {
            #if DEBUG
            return .development
            #else
            return .production
            #endif
        }
    }
    
    // MARK: - API Configuration
    enum API {
        static var baseURL: String {
            switch Environment.current {
            case .development:
                return "http://localhost:3000/api"
            case .staging:
                return "https://staging-api.flour.app/api"
            case .production:
                return "https://api.flour.app/api"
            }
        }
    }
    
    // MARK: - Firebase
    // Firebase configuration is loaded from GoogleService-Info.plist
    
    // MARK: - Stripe
    enum Stripe {
        static var publishableKey: String {
            switch Environment.current {
            case .development, .staging:
                return "pk_test_YOUR_TEST_KEY_HERE"
            case .production:
                return "pk_live_YOUR_LIVE_KEY_HERE"
            }
        }
    }
    
    // MARK: - App Configuration
    enum App {
        static let bundleIdentifier = "com.flour.app"
        static let appStoreID = "YOUR_APP_STORE_ID"
        static let minimumIOSVersion = "17.0"
    }
    
    // MARK: - Feature Flags
    enum Features {
        static let enablePushNotifications = true
        static let enableAnalytics = false // Disabled for MVP
        static let enableCrashReporting = false // Disabled for MVP
    }
    
    // MARK: - Request Defaults
    enum Defaults {
        static let requestDurationHours = 2.0
        static let defaultRadiusMeters = 800.0 // ~10 min walk
        static let maxRadiusMeters = 1600.0 // ~20 min walk
        static let platformFeePercentage = 0.10 // 10%
        static let platformFeeCap = 2.00 // $2 max
    }
}
