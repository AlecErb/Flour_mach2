//
//  MockData.swift
//  Flour
//
//  Created on 2026-02-06.
//
//  Mock data for testing and SwiftUI previews

import Foundation
import CoreLocation

enum MockData {
    // MARK: - Schools
    
    static let stanford = School(
        id: "school_1",
        name: "Stanford University",
        domain: "stanford.edu"
    )
    
    static let usc = School(
        id: "school_2",
        name: "University of Southern California",
        domain: "usc.edu"
    )
    
    static let berkeley = School(
        id: "school_3",
        name: "UC Berkeley",
        domain: "berkeley.edu"
    )
    
    static let schools = [stanford, usc, berkeley]
    
    // MARK: - Users
    
    static let currentUser = User(
        id: "user_current",
        displayName: "Alex Chen",
        email: "alex.chen@stanford.edu",
        phone: "+1234567890",
        schoolId: stanford.id,
        rating: 4.8,
        totalTransactions: 15
    )
    
    static let user2 = User(
        id: "user_2",
        displayName: "Sarah Johnson",
        email: "sarah.j@stanford.edu",
        phone: "+1234567891",
        schoolId: stanford.id,
        rating: 4.9,
        totalTransactions: 23
    )
    
    static let user3 = User(
        id: "user_3",
        displayName: "Mike Davis",
        email: "mike.davis@stanford.edu",
        phone: "+1234567892",
        schoolId: stanford.id,
        rating: 4.6,
        totalTransactions: 8
    )
    
    static let user4 = User(
        id: "user_4",
        displayName: "Emily Rodriguez",
        email: "emily.r@stanford.edu",
        phone: "+1234567893",
        schoolId: stanford.id,
        rating: 5.0,
        totalTransactions: 31
    )
    
    static let users = [currentUser, user2, user3, user4]
    
    // MARK: - Locations (Stanford campus area)
    
    static let stanfordLocation = LocationCoordinate(
        latitude: 37.4275,
        longitude: -122.1697
    )
    
    static let location2 = LocationCoordinate(
        latitude: 37.4290,
        longitude: -122.1700
    )
    
    static let location3 = LocationCoordinate(
        latitude: 37.4265,
        longitude: -122.1710
    )
    
    // MARK: - Requests
    
    static let iceRequest = Request(
        id: "request_1",
        requesterId: user2.id,
        itemDescription: "Need 2 bags of ice for party",
        offerPrice: 10.00,
        urgency: .asap,
        radiusMeters: 800,
        location: stanfordLocation,
        status: .open
    )
    
    static let chargerRequest = Request(
        id: "request_2",
        requesterId: user3.id,
        itemDescription: "iPhone charger (USB-C)",
        offerPrice: 5.00,
        urgency: .thirtyMinutes,
        radiusMeters: 500,
        location: location2,
        status: .open
    )
    
    static let costumeRequest = Request(
        id: "request_3",
        requesterId: user4.id,
        itemDescription: "Black tie for tonight's event",
        offerPrice: 15.00,
        urgency: .oneHour,
        radiusMeters: 1000,
        location: location3,
        status: .negotiating
    )
    
    static let advilRequest = Request(
        id: "request_4",
        requesterId: currentUser.id,
        itemDescription: "Advil or ibuprofen - headache",
        offerPrice: 3.00,
        urgency: .asap,
        radiusMeters: 600,
        location: stanfordLocation,
        status: .matched,
        fulfillerId: user2.id
    )
    
    static let eggsRequest = Request(
        id: "request_5",
        requesterId: user2.id,
        itemDescription: "Need eggs for baking (6-12)",
        offerPrice: 5.00,
        urgency: .flexible,
        radiusMeters: 1200,
        location: location2,
        status: .open
    )
    
    static let speakerRequest = Request(
        id: "request_6",
        requesterId: user3.id,
        itemDescription: "Bluetooth speaker for 2 hours",
        offerPrice: 20.00,
        urgency: .oneHour,
        radiusMeters: 800,
        location: location3,
        status: .completed,
        fulfillerId: currentUser.id
    )
    
    static let requests = [
        iceRequest,
        chargerRequest,
        costumeRequest,
        advilRequest,
        eggsRequest,
        speakerRequest
    ]
    
    static let activeRequests = requests.filter { $0.isActive }
    
    // MARK: - Offers
    
    static let offer1 = Offer(
        id: "offer_1",
        requestId: costumeRequest.id,
        userId: currentUser.id,
        amount: 15.00,
        status: .pending
    )
    
    static let offer2 = Offer(
        id: "offer_2",
        requestId: costumeRequest.id,
        userId: user4.id,
        amount: 12.00,
        status: .countered,
        parentOfferId: offer1.id
    )
    
    static let offer3 = Offer(
        id: "offer_3",
        requestId: iceRequest.id,
        userId: currentUser.id,
        amount: 10.00,
        status: .accepted
    )
    
    static let offers = [offer1, offer2, offer3]
    
    // MARK: - Transactions
    
    static let transaction1 = Transaction(
        id: "transaction_1",
        requestId: advilRequest.id,
        requesterId: currentUser.id,
        fulfillerId: user2.id,
        itemPrice: 3.00,
        status: .pending,
        requesterConfirmed: false,
        fulfillerConfirmed: false
    )
    
    static let transaction2 = Transaction(
        id: "transaction_2",
        requestId: speakerRequest.id,
        requesterId: user3.id,
        fulfillerId: currentUser.id,
        itemPrice: 20.00,
        status: .completed,
        requesterConfirmed: true,
        fulfillerConfirmed: true,
        completedAt: Date().addingTimeInterval(-3600) // 1 hour ago
    )
    
    static let transactions = [transaction1, transaction2]
    
    // MARK: - Messages
    
    static let message1 = Message(
        id: "message_1",
        transactionId: transaction1.id,
        senderId: currentUser.id,
        content: "Hey! Do you have Advil?",
        createdAt: Date().addingTimeInterval(-600), // 10 min ago
        isRead: true
    )
    
    static let message2 = Message(
        id: "message_2",
        transactionId: transaction1.id,
        senderId: user2.id,
        content: "Yes! I can bring it to you in 5 minutes",
        createdAt: Date().addingTimeInterval(-540), // 9 min ago
        isRead: true
    )
    
    static let message3 = Message(
        id: "message_3",
        transactionId: transaction1.id,
        senderId: currentUser.id,
        content: "Perfect! I'm at the library",
        createdAt: Date().addingTimeInterval(-480), // 8 min ago
        isRead: true
    )
    
    static let message4 = Message(
        id: "message_4",
        transactionId: transaction1.id,
        senderId: user2.id,
        content: "On my way!",
        createdAt: Date().addingTimeInterval(-420), // 7 min ago
        isRead: false
    )
    
    static let messages = [message1, message2, message3, message4]
    
    // MARK: - Helper Functions
    
    /// Get messages for a specific transaction
    static func messages(for transactionId: String) -> [Message] {
        return messages.filter { $0.transactionId == transactionId }
    }
    
    /// Get requests for a specific user
    static func requests(for userId: String) -> [Request] {
        return requests.filter { $0.requesterId == userId }
    }
    
    /// Get transactions for a specific user
    static func transactions(for userId: String) -> [Transaction] {
        return transactions.filter {
            $0.requesterId == userId || $0.fulfillerId == userId
        }
    }
    
    /// Get offers for a specific request
    static func offers(for requestId: String) -> [Offer] {
        return offers.filter { $0.requestId == requestId }
    }
    
    /// Get user by ID
    static func user(withId id: String) -> User? {
        return users.first { $0.id == id }
    }
    
    /// Get school by ID
    static func school(withId id: String) -> School? {
        return schools.first { $0.id == id }
    }
}
