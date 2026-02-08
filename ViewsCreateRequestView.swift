//
//  CreateRequestView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsCreateRequestView: View {
	@Environment(AppState.self) private var appState
	@Environment(LocationService.self) private var locationService
	@Environment(\.dismiss) private var dismiss

	var onRequestCreated: ((Request) -> Void)?

	@State private var itemDescription = ""
	@State private var offerPrice = 10.0
	@State private var urgency: Urgency = .oneHour
	@State private var radiusMeters: Double = Constants.Request.defaultRadiusMeters
	@State private var durationHours: Double = Constants.Request.defaultDurationHours

	private var isValid: Bool {
		!itemDescription.trimmingCharacters(in: .whitespaces).isEmpty &&
		offerPrice >= Constants.Request.minPrice &&
		offerPrice <= Constants.Request.maxPrice
	}

	private var platformFee: Double {
		Transaction.calculatePlatformFee(for: offerPrice)
	}

	private var total: Double {
		offerPrice + platformFee
	}

	var body: some View {
		Form {
			Section("What do you need?") {
				TextField("e.g., 2 bags of ice, phone charger...", text: $itemDescription, axis: .vertical)
					.lineLimit(2...4)
			}

			Section("Your offer") {
				HStack {
					Text("Price")
					Spacer()
					TextField("$", value: $offerPrice, format: .currency(code: "USD"))
						.keyboardType(.decimalPad)
						.multilineTextAlignment(.trailing)
						.frame(width: 100)
				}

				HStack {
					Text("Platform fee")
						.foregroundStyle(.secondary)
					Spacer()
					Text(String(format: "$%.2f", platformFee))
						.foregroundStyle(.secondary)
				}

				HStack {
					Text("Total")
						.fontWeight(.semibold)
					Spacer()
					Text(String(format: "$%.2f", total))
						.fontWeight(.semibold)
				}
			}

			Section("Urgency") {
				Picker("How soon?", selection: $urgency) {
					ForEach(Urgency.allCases, id: \.self) { level in
						Text(level.displayName).tag(level)
					}
				}
				.pickerStyle(.segmented)
			}

			Section("Search radius") {
				VStack(alignment: .leading) {
					Text("\(Int(radiusMeters))m (~\(Int(radiusMeters / 80)) min walk)")
						.font(.subheadline)
						.foregroundStyle(.secondary)
					Slider(
						value: $radiusMeters,
						in: Constants.Request.minRadiusMeters...Constants.Request.maxRadiusMeters,
						step: 100
					)
				}
			}

			Section("Duration") {
				VStack(alignment: .leading) {
					Text(durationHours < 1 ? "\(Int(durationHours * 60)) minutes" : "\(Int(durationHours)) hours")
						.font(.subheadline)
						.foregroundStyle(.secondary)
					Slider(
						value: $durationHours,
						in: Constants.Request.minDurationHours...Constants.Request.maxDurationHours,
						step: 0.5
					)
				}
			}
		}
		.navigationTitle("New Request")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel") { dismiss() }
			}
			ToolbarItem(placement: .confirmationAction) {
				Button("Post") {
					let newRequest = appState.createRequest(
						itemDescription: itemDescription.trimmingCharacters(in: .whitespaces),
						offerPrice: offerPrice,
						urgency: urgency,
						radiusMeters: radiusMeters,
						location: locationService.currentLocationCoordinate,
						durationHours: durationHours
					)
					dismiss()
					onRequestCreated?(newRequest)
				}
				.disabled(!isValid)
				.fontWeight(.semibold)
			}
		}
	}
}
