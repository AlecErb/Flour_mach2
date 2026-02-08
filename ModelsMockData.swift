//
//  MockData.swift
//  Flour
//
//  Created on 2026-02-06.
//
//  Mock data for testing and SwiftUI previews
//  Centered on Salt Lake City / University of Utah campus

import Foundation
import CoreLocation

enum MockData {
	// MARK: - Schools

	static let uOfU = School(
		id: "school_1",
		name: "University of Utah",
		domain: "utah.edu"
	)

	static let byu = School(
		id: "school_2",
		name: "Brigham Young University",
		domain: "byu.edu"
	)

	static let usu = School(
		id: "school_3",
		name: "Utah State University",
		domain: "usu.edu"
	)

	static let westminster = School(
		id: "school_4",
		name: "Westminster University",
		domain: "westminsteru.edu"
	)

	static let slcc = School(
		id: "school_5",
		name: "Salt Lake Community College",
		domain: "slcc.edu"
	)

	static let schools = [uOfU, byu, usu, westminster, slcc]

	// MARK: - Users

	static let currentUser = User(
		id: "user_current",
		displayName: "Alec",
		email: "alec@utah.edu",
		phone: "+18015551234",
		schoolId: uOfU.id,
		rating: 4.8,
		totalTransactions: 15
	)

	static let user2 = User(
		id: "user_2",
		displayName: "Jordan Kim",
		email: "jordan.kim@utah.edu",
		phone: "+18015551001",
		schoolId: uOfU.id,
		rating: 4.9,
		totalTransactions: 23
	)

	static let user3 = User(
		id: "user_3",
		displayName: "Mia Patel",
		email: "mia.patel@utah.edu",
		phone: "+18015551002",
		schoolId: uOfU.id,
		rating: 4.6,
		totalTransactions: 8
	)

	static let user4 = User(
		id: "user_4",
		displayName: "Chris Henriksen",
		email: "chris.h@utah.edu",
		phone: "+18015551003",
		schoolId: uOfU.id,
		rating: 5.0,
		totalTransactions: 31
	)

	static let user5 = User(
		id: "user_5",
		displayName: "Lily Nguyen",
		email: "lily.nguyen@utah.edu",
		phone: "+18015551004",
		schoolId: uOfU.id,
		rating: 4.7,
		totalTransactions: 12
	)

	static let user6 = User(
		id: "user_6",
		displayName: "Tyler Morrison",
		email: "tyler.m@utah.edu",
		phone: "+18015551005",
		schoolId: uOfU.id,
		rating: 4.4,
		totalTransactions: 5
	)

	static let user7 = User(
		id: "user_7",
		displayName: "Sophie Andersen",
		email: "sophie.a@utah.edu",
		phone: "+18015551006",
		schoolId: uOfU.id,
		rating: 4.9,
		totalTransactions: 19
	)

	static let user8 = User(
		id: "user_8",
		displayName: "Marcus Rivera",
		email: "marcus.r@utah.edu",
		phone: "+18015551007",
		schoolId: uOfU.id,
		rating: 4.5,
		totalTransactions: 7
	)

	static let users = [currentUser, user2, user3, user4, user5, user6, user7, user8]

	// MARK: - Locations (Salt Lake City / University of Utah campus area)

	// University of Utah campus center (~Union Building)
	static let campusCenter = LocationCoordinate(
		latitude: 40.7649,
		longitude: -111.8421
	)

	// Marriott Library
	static let nearLibrary = LocationCoordinate(
		latitude: 40.7641,
		longitude: -111.8479
	)

	// Student housing / Heritage Commons
	static let nearDorms = LocationCoordinate(
		latitude: 40.7670,
		longitude: -111.8450
	)

	// Rice-Eccles Stadium area
	static let nearStadium = LocationCoordinate(
		latitude: 40.7601,
		longitude: -111.8490
	)

	// Presidents Circle
	static let presidentsCircle = LocationCoordinate(
		latitude: 40.7640,
		longitude: -111.8510
	)

	// Near TRAX station (university line)
	static let nearTrax = LocationCoordinate(
		latitude: 40.7660,
		longitude: -111.8400
	)

	// Lassonde Studios (entrepreneurship center)
	static let lassonde = LocationCoordinate(
		latitude: 40.7688,
		longitude: -111.8435
	)

	// Near Kingsbury Hall
	static let nearKingsbury = LocationCoordinate(
		latitude: 40.7630,
		longitude: -111.8505
	)

	// 9th & 9th neighborhood (just south of campus)
	static let ninthAndNinth = LocationCoordinate(
		latitude: 40.7440,
		longitude: -111.8570
	)

	// Sugar House area
	static let sugarHouse = LocationCoordinate(
		latitude: 40.7223,
		longitude: -111.8585
	)

	// Park Building / red brick buildings area
	static let redBuildings = LocationCoordinate(
		latitude: 40.7655,
		longitude: -111.8470
	)

	// MARK: - Requests

	static let iceRequest = Request(
		id: "request_1",
		requesterId: user2.id,
		itemDescription: "Need 2 bags of ice for party tonight",
		offerPrice: 10.00,
		urgency: .asap,
		radiusMeters: 800,
		location: nearDorms,
		status: .open
	)

	static let chargerRequest = Request(
		id: "request_2",
		requesterId: user3.id,
		itemDescription: "iPhone charger (USB-C) — mine broke",
		offerPrice: 5.00,
		urgency: .thirtyMinutes,
		radiusMeters: 500,
		location: nearLibrary,
		status: .open
	)

	static let costumeRequest = Request(
		id: "request_3",
		requesterId: user4.id,
		itemDescription: "Black tie for tonight's event at Kingsbury",
		offerPrice: 15.00,
		urgency: .oneHour,
		radiusMeters: 1000,
		location: nearKingsbury,
		status: .negotiating
	)

	static let advilRequest = Request(
		id: "request_4",
		requesterId: currentUser.id,
		itemDescription: "Advil or ibuprofen — bad headache",
		offerPrice: 3.00,
		urgency: .asap,
		radiusMeters: 600,
		location: campusCenter,
		status: .matched,
		fulfillerId: user2.id
	)

	static let eggsRequest = Request(
		id: "request_5",
		requesterId: user5.id,
		itemDescription: "Need eggs for baking (half dozen is fine)",
		offerPrice: 5.00,
		urgency: .flexible,
		radiusMeters: 1200,
		location: ninthAndNinth,
		status: .open
	)

	static let speakerRequest = Request(
		id: "request_6",
		requesterId: user6.id,
		itemDescription: "Bluetooth speaker for tailgate at Rice-Eccles",
		offerPrice: 20.00,
		urgency: .oneHour,
		radiusMeters: 800,
		location: nearStadium,
		status: .completed,
		fulfillerId: currentUser.id
	)

	static let extensionCordRequest = Request(
		id: "request_7",
		requesterId: user7.id,
		itemDescription: "Extension cord — 10ft minimum",
		offerPrice: 8.00,
		urgency: .thirtyMinutes,
		radiusMeters: 500,
		location: lassonde,
		status: .open
	)

	static let coughDropsRequest = Request(
		id: "request_8",
		requesterId: user8.id,
		itemDescription: "Cough drops or throat lozenges — dying here",
		offerPrice: 4.00,
		urgency: .asap,
		radiusMeters: 700,
		location: nearTrax,
		status: .open
	)

	static let pingPongRequest = Request(
		id: "request_9",
		requesterId: user2.id,
		itemDescription: "Ping pong balls (pack of 6+)",
		offerPrice: 6.00,
		urgency: .flexible,
		radiusMeters: 1000,
		location: nearDorms,
		status: .open
	)

	static let hdmiRequest = Request(
		id: "request_10",
		requesterId: user5.id,
		itemDescription: "HDMI cable for presentation in 30 min",
		offerPrice: 7.00,
		urgency: .asap,
		radiusMeters: 400,
		location: presidentsCircle,
		status: .open
	)

	static let umbrellaRequest = Request(
		id: "request_11",
		requesterId: user3.id,
		itemDescription: "Umbrella — storm rolling in",
		offerPrice: 5.00,
		urgency: .asap,
		radiusMeters: 600,
		location: campusCenter,
		status: .open
	)

	static let snacksRequest = Request(
		id: "request_12",
		requesterId: user6.id,
		itemDescription: "Snacks for study group (chips, candy, whatever)",
		offerPrice: 12.00,
		urgency: .oneHour,
		radiusMeters: 800,
		location: nearLibrary,
		status: .open
	)

	static let screwdriverRequest = Request(
		id: "request_13",
		requesterId: user7.id,
		itemDescription: "Phillips head screwdriver — assembling desk",
		offerPrice: 5.00,
		urgency: .thirtyMinutes,
		radiusMeters: 500,
		location: lassonde,
		status: .negotiating
	)

	static let bandaidsRequest = Request(
		id: "request_14",
		requesterId: user4.id,
		itemDescription: "Band-aids — scraped my knee skating",
		offerPrice: 3.00,
		urgency: .asap,
		radiusMeters: 400,
		location: nearTrax,
		status: .open
	)

	static let coffeeRequest = Request(
		id: "request_15",
		requesterId: user6.id,
		itemDescription: "Coffee from anywhere — pulling an all-nighter",
		offerPrice: 8.00,
		urgency: .thirtyMinutes,
		radiusMeters: 1000,
		location: nearLibrary,
		status: .open
	)

	static let notesRequest = Request(
		id: "request_16",
		requesterId: user3.id,
		itemDescription: "Bio 1610 lecture notes from yesterday",
		offerPrice: 10.00,
		urgency: .oneHour,
		radiusMeters: 800,
		location: campusCenter,
		status: .open
	)

	static let calculatorRequest = Request(
		id: "request_17",
		requesterId: user8.id,
		itemDescription: "Scientific calculator for exam tomorrow",
		offerPrice: 15.00,
		urgency: .asap,
		radiusMeters: 600,
		location: nearDorms,
		status: .open
	)

	static let bikeRequest = Request(
		id: "request_18",
		requesterId: user2.id,
		itemDescription: "Bike pump — flat tire",
		offerPrice: 5.00,
		urgency: .flexible,
		radiusMeters: 1200,
		location: redBuildings,
		status: .open
	)

	static let textbookRequest = Request(
		id: "request_19",
		requesterId: user5.id,
		itemDescription: "Chemistry textbook to borrow for the weekend",
		offerPrice: 20.00,
		urgency: .flexible,
		radiusMeters: 1000,
		location: nearLibrary,
		status: .open
	)

	static let mascaraRequest = Request(
		id: "request_20",
		requesterId: user7.id,
		itemDescription: "Black mascara — have a date in 30 min",
		offerPrice: 8.00,
		urgency: .asap,
		radiusMeters: 500,
		location: ninthAndNinth,
		status: .open
	)

	static let tapeRequest = Request(
		id: "request_21",
		requesterId: user4.id,
		itemDescription: "Packing tape for shipping a box",
		offerPrice: 4.00,
		urgency: .oneHour,
		radiusMeters: 800,
		location: nearKingsbury,
		status: .open
	)

	static let penRequest = Request(
		id: "request_22",
		requesterId: user6.id,
		itemDescription: "Black pen — mine died during exam",
		offerPrice: 2.00,
		urgency: .asap,
		radiusMeters: 300,
		location: lassonde,
		status: .open
	)

	static let laundryRequest = Request(
		id: "request_23",
		requesterId: user8.id,
		itemDescription: "Laundry detergent pods (just need a few)",
		offerPrice: 5.00,
		urgency: .flexible,
		radiusMeters: 600,
		location: nearDorms,
		status: .open
	)

	static let usbRequest = Request(
		id: "request_24",
		requesterId: user3.id,
		itemDescription: "USB-A to USB-C adapter",
		offerPrice: 7.00,
		urgency: .thirtyMinutes,
		radiusMeters: 700,
		location: campusCenter,
		status: .open
	)

	static let energyDrinkRequest = Request(
		id: "request_25",
		requesterId: user2.id,
		itemDescription: "Energy drink (any brand) — dead tired",
		offerPrice: 5.00,
		urgency: .asap,
		radiusMeters: 900,
		location: nearLibrary,
		status: .open
	)

	static let hairTieRequest = Request(
		id: "request_26",
		requesterId: user5.id,
		itemDescription: "Hair tie or scrunchie for workout",
		offerPrice: 2.00,
		urgency: .thirtyMinutes,
		radiusMeters: 500,
		location: redBuildings,
		status: .open
	)

	static let printingRequest = Request(
		id: "request_27",
		requesterId: user7.id,
		itemDescription: "Print 5 pages — printer's broken",
		offerPrice: 4.00,
		urgency: .oneHour,
		radiusMeters: 800,
		location: nearLibrary,
		status: .open
	)

	static let quartersRequest = Request(
		id: "request_28",
		requesterId: user4.id,
		itemDescription: "$10 in quarters for laundry",
		offerPrice: 11.00,
		urgency: .flexible,
		radiusMeters: 1000,
		location: nearDorms,
		status: .open
	)

	static let gumRequest = Request(
		id: "request_29",
		requesterId: user6.id,
		itemDescription: "Gum (any flavor) — need fresh breath",
		offerPrice: 3.00,
		urgency: .thirtyMinutes,
		radiusMeters: 400,
		location: ninthAndNinth,
		status: .open
	)

	static let napkinsRequest = Request(
		id: "request_30",
		requesterId: user8.id,
		itemDescription: "Paper napkins or tissues — spilled coffee",
		offerPrice: 2.00,
		urgency: .asap,
		radiusMeters: 300,
		location: campusCenter,
		status: .open
	)

	static let requests = [
		iceRequest,
		chargerRequest,
		costumeRequest,
		advilRequest,
		eggsRequest,
		speakerRequest,
		extensionCordRequest,
		coughDropsRequest,
		pingPongRequest,
		hdmiRequest,
		umbrellaRequest,
		snacksRequest,
		screwdriverRequest,
		bandaidsRequest,
		coffeeRequest,
		notesRequest,
		calculatorRequest,
		bikeRequest,
		textbookRequest,
		mascaraRequest,
		tapeRequest,
		penRequest,
		laundryRequest,
		usbRequest,
		energyDrinkRequest,
		hairTieRequest,
		printingRequest,
		quartersRequest,
		gumRequest,
		napkinsRequest
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

	static let offer4 = Offer(
		id: "offer_4",
		requestId: screwdriverRequest.id,
		userId: user8.id,
		amount: 5.00,
		status: .pending
	)

	static let offer5 = Offer(
		id: "offer_5",
		requestId: hdmiRequest.id,
		userId: currentUser.id,
		amount: 7.00,
		status: .pending
	)

	static let offers = [offer1, offer2, offer3, offer4, offer5]

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
		requesterId: user6.id,
		fulfillerId: currentUser.id,
		itemPrice: 20.00,
		status: .completed,
		requesterConfirmed: true,
		fulfillerConfirmed: true,
		completedAt: Date().addingTimeInterval(-3600)
	)

	static let transactions = [transaction1, transaction2]

	// MARK: - Messages

	static let message1 = Message(
		id: "message_1",
		transactionId: transaction1.id,
		senderId: currentUser.id,
		content: "Hey! Do you have Advil?",
		createdAt: Date().addingTimeInterval(-600),
		isRead: true
	)

	static let message2 = Message(
		id: "message_2",
		transactionId: transaction1.id,
		senderId: user2.id,
		content: "Yeah I've got some! Where are you?",
		createdAt: Date().addingTimeInterval(-540),
		isRead: true
	)

	static let message3 = Message(
		id: "message_3",
		transactionId: transaction1.id,
		senderId: currentUser.id,
		content: "I'm in the Union Building, first floor by the bookstore",
		createdAt: Date().addingTimeInterval(-480),
		isRead: true
	)

	static let message4 = Message(
		id: "message_4",
		transactionId: transaction1.id,
		senderId: user2.id,
		content: "Perfect, I'm at Heritage Commons. Be there in 5!",
		createdAt: Date().addingTimeInterval(-420),
		isRead: false
	)

	static let message5 = Message(
		id: "message_5",
		transactionId: transaction2.id,
		senderId: user6.id,
		content: "Hey can you bring the speaker to gate 5?",
		createdAt: Date().addingTimeInterval(-7200),
		isRead: true
	)

	static let message6 = Message(
		id: "message_6",
		transactionId: transaction2.id,
		senderId: currentUser.id,
		content: "On my way, be there in 3 min",
		createdAt: Date().addingTimeInterval(-7140),
		isRead: true
	)

	static let messages = [message1, message2, message3, message4, message5, message6]

	// MARK: - Helper Functions

	static func messages(for transactionId: String) -> [Message] {
		return messages.filter { $0.transactionId == transactionId }
	}

	static func requestsForUser(_ userId: String) -> [Request] {
		return requests.filter { $0.requesterId == userId }
	}

	static func transactions(for userId: String) -> [Transaction] {
		return transactions.filter {
			$0.requesterId == userId || $0.fulfillerId == userId
		}
	}

	static func offers(for requestId: String) -> [Offer] {
		return offers.filter { $0.requestId == requestId }
	}

	static func user(withId id: String) -> User? {
		return users.first { $0.id == id }
	}

	static func school(withId id: String) -> School? {
		return schools.first { $0.id == id }
	}
}
