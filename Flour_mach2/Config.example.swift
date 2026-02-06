//
//  Config.example.swift
//  Flour
//
//  Created on 2026-02-05.
//  Copy this file to Config.swift and fill in your actual values.
//  Config.swift is in .gitignore and will not be committed.
//

import Foundation

enum Config {
    
    // MARK: - Firebase Configuration
    // Get these from your Firebase project settings
    static let firebaseAPIKey = "YOUR_FIREBASE_API_KEY"
    static let firebaseProjectID = "YOUR_PROJECT_ID"
    static let firebaseAppID = "YOUR_APP_ID"
    
    // MARK: - Stripe Configuration
    // Get these from your Stripe dashboard
    static let stripePublishableKey = "pk_test_YOUR_PUBLISHABLE_KEY"
    
    // MARK: - Backend API Configuration
    static let apiBaseURL: String = {
        #if DEBUG
        return "http://localhost:3000/api" // Local development
        #else
        return "https://api.flour.app/v1" // Production
        #endif
    }()
    
    // MARK: - App Configuration
    static let defaultRequestRadius: Double = 800 // meters (~10 min walk)
    static let defaultRequestDuration: TimeInterval = 7200 // 2 hours in seconds
    static let platformFeePercentage: Double = 0.10 // 10%
    static let platformFeeMaximum: Double = 2.00 // $2 cap
    
    // MARK: - Feature Flags
    static let enablePushNotifications = true
    static let enableChat = true
    static let enablePayments = true
    static let enableAnalytics = false // For MVP
    
}
