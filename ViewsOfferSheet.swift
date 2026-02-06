//
//  OfferSheet.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsOfferSheet: View {
	@Environment(AppState.self) private var appState
	@Environment(\.dismiss) private var dismiss

	let request: Request

	@State private var offerAmount: Double = 0
	@State private var isCounter = false
	@State private var counterOfferId: String?

	init(request: Request, counterOfferId: String? = nil) {
		self.request = request
		self._offerAmount = State(initialValue: request.offerPrice)
		self._counterOfferId = State(initialValue: counterOfferId)
		self._isCounter = State(initialValue: counterOfferId != nil)
	}

	private var platformFee: Double {
		Transaction.calculatePlatformFee(for: offerAmount)
	}

	var body: some View {
		VStack(spacing: 24) {
			Text(isCounter ? "Counter Offer" : "Make an Offer")
				.font(.title3)
				.fontWeight(.semibold)

			Text("for \"\(request.itemDescription)\"")
				.font(.subheadline)
				.foregroundStyle(.secondary)

			VStack(spacing: 8) {
				Text("Suggested: \(request.formattedPrice)")
					.font(.caption)
					.foregroundStyle(.secondary)

				HStack {
					Text("$")
						.font(.title)
						.fontWeight(.semibold)
					TextField("0.00", value: $offerAmount, format: .number.precision(.fractionLength(2)))
						.keyboardType(.decimalPad)
						.font(.system(size: 36, weight: .bold))
						.multilineTextAlignment(.center)
						.frame(width: 120)
				}
			}

			SharedFeeBreakdownView(itemPrice: offerAmount)

			Spacer()

			Button {
				if isCounter, let counterId = counterOfferId {
					appState.counterOffer(counterId, newAmount: offerAmount)
				} else {
					appState.makeOffer(requestId: request.id, amount: offerAmount)
				}
				dismiss()
			} label: {
				Text(isCounter ? "Send Counter Offer" : "Send Offer")
					.font(.headline)
					.frame(maxWidth: .infinity)
					.frame(height: Constants.UI.buttonHeight)
			}
			.buttonStyle(.borderedProminent)
			.tint(.green)
			.disabled(offerAmount < Constants.Request.minPrice)
		}
		.padding()
		.navigationTitle(isCounter ? "Counter Offer" : "New Offer")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel") { dismiss() }
			}
		}
	}
}
