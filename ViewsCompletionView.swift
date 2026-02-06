//
//  CompletionView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsCompletionView: View {
	@Environment(AppState.self) private var appState
	@Environment(\.dismiss) private var dismiss

	let transaction: Transaction

	private var userId: String { appState.currentUser?.id ?? "" }

	private var currentTransaction: Transaction {
		appState.transactions.first { $0.id == transaction.id } ?? transaction
	}

	private var isRequester: Bool {
		currentTransaction.requesterId == userId
	}

	private var iConfirmed: Bool {
		isRequester ? currentTransaction.requesterConfirmed : currentTransaction.fulfillerConfirmed
	}

	private var otherConfirmed: Bool {
		isRequester ? currentTransaction.fulfillerConfirmed : currentTransaction.requesterConfirmed
	}

	private var otherUser: User? {
		let otherId = isRequester ? currentTransaction.fulfillerId : currentTransaction.requesterId
		return appState.user(withId: otherId)
	}

	private var relatedRequest: Request? {
		appState.requests.first { $0.id == currentTransaction.requestId }
	}

	var body: some View {
		VStack(spacing: 24) {
			if currentTransaction.isCompleted {
				completedState
			} else {
				confirmationState
			}
		}
		.padding()
		.navigationTitle("Complete Transaction")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Close") { dismiss() }
			}
		}
	}

	private var confirmationState: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: "checkmark.shield")
				.font(.system(size: 56))
				.foregroundStyle(.green)

			Text("Confirm Delivery")
				.font(.title2)
				.fontWeight(.semibold)

			if let request = relatedRequest {
				Text(request.itemDescription)
					.font(.body)
					.foregroundStyle(.secondary)
			}

			SharedFeeBreakdownView(itemPrice: currentTransaction.itemPrice)

			// Confirmation status
			VStack(spacing: 12) {
				confirmationRow(
					label: "You",
					confirmed: iConfirmed
				)
				confirmationRow(
					label: otherUser?.displayName ?? "Other party",
					confirmed: otherConfirmed
				)
			}
			.padding()
			.background(Color.gray.opacity(0.12))
			.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))

			Spacer()

			if !iConfirmed {
				Button {
					appState.confirmTransaction(currentTransaction.id)
				} label: {
					Text("Confirm Completed")
						.font(.headline)
						.frame(maxWidth: .infinity)
						.frame(height: Constants.UI.buttonHeight)
				}
				.buttonStyle(.borderedProminent)
				.tint(.green)
			} else {
				Text("Waiting for \(otherUser?.displayName ?? "other party") to confirm...")
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
			}
		}
	}

	private var completedState: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: "party.popper.fill")
				.font(.system(size: 64))
				.foregroundStyle(.green)

			Text("Transaction Complete!")
				.font(.title)
				.fontWeight(.bold)

			Text("Both parties confirmed. The transaction is done.")
				.font(.body)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)

			SharedFeeBreakdownView(itemPrice: currentTransaction.itemPrice)

			Spacer()

			Button {
				dismiss()
			} label: {
				Text("Done")
					.font(.headline)
					.frame(maxWidth: .infinity)
					.frame(height: Constants.UI.buttonHeight)
			}
			.buttonStyle(.borderedProminent)
			.tint(.green)
		}
	}

	private func confirmationRow(label: String, confirmed: Bool) -> some View {
		HStack {
			Text(label)
				.font(.subheadline)
			Spacer()
			Image(systemName: confirmed ? "checkmark.circle.fill" : "circle")
				.foregroundStyle(confirmed ? .green : .secondary)
		}
	}
}
