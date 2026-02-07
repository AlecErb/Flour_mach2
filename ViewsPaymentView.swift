//
//  PaymentView.swift
//  Flour
//
//  Payment processing view for buyers
//

import SwiftUI

struct PaymentView: View {
	@Environment(AppState.self) private var appState
	let transaction: Transaction

	@State private var isProcessing = false
	@State private var errorMessage: String?
	@State private var paymentSucceeded = false

	var body: some View {
		VStack(spacing: 24) {
			// Header
			VStack(spacing: 8) {
				Image(systemName: "creditcard.fill")
					.font(.system(size: 48))
					.foregroundStyle(.blue)

				Text("Complete Payment")
					.font(.title2)
					.fontWeight(.semibold)

				Text("Secure payment powered by Stripe")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			.padding(.top, 32)

			// Fee breakdown
			SharedFeeBreakdownView(itemPrice: transaction.itemPrice)
				.padding(.horizontal)

			Spacer()

			if paymentSucceeded {
				// Success state
				VStack(spacing: 16) {
					Image(systemName: "checkmark.circle.fill")
						.font(.system(size: 64))
						.foregroundStyle(.green)

					Text("Payment Successful!")
						.font(.title3)
						.fontWeight(.semibold)

					Text("The seller has been notified and will fulfill your request.")
						.font(.subheadline)
						.foregroundStyle(.secondary)
						.multilineTextAlignment(.center)
						.padding(.horizontal)
				}
				.padding(.vertical, 32)
			} else {
				// Pay button
				Button {
					processPayment()
				} label: {
					if isProcessing {
						ProgressView()
							.progressViewStyle(.circular)
							.tint(.white)
					} else {
						Text("Pay \(transaction.formattedTotal)")
							.fontWeight(.semibold)
					}
				}
				.buttonStyle(.borderedProminent)
				.controlSize(.large)
				.disabled(isProcessing)
			}

			if let error = errorMessage {
				Text(error)
					.font(.caption)
					.foregroundStyle(.red)
					.multilineTextAlignment(.center)
					.padding(.horizontal)
			}

			Spacer()
		}
		.navigationTitle("Payment")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func processPayment() {
		Task {
			isProcessing = true
			errorMessage = nil

			do {
				// In a real implementation, you would:
				// 1. Get the client secret from your backend
				// let clientSecret = try await appState.createPayment(for: transaction.id)
				//
				// 2. Present Stripe Payment Sheet with the client secret
				// let paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret)
				// let result = await paymentSheet.present()
				//
				// 3. Handle the result
				// if case .completed = result {
				//     appState.markPaymentSucceeded(transactionId: transaction.id)
				//     paymentSucceeded = true
				// }

				// For MVP/testing, simulate successful payment
				try await Task.sleep(for: .seconds(2))
				appState.markPaymentSucceeded(transactionId: transaction.id)
				paymentSucceeded = true

			} catch {
				errorMessage = error.localizedDescription
				appState.markPaymentFailed(transactionId: transaction.id, error: error.localizedDescription)
			}

			isProcessing = false
		}
	}
}

#Preview {
	NavigationStack {
		PaymentView(transaction: MockData.transactions[0])
			.environment(AppState())
	}
}
