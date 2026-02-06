//
//  NegotiationHistoryView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsNegotiationHistoryView: View {
	@Environment(AppState.self) private var appState
	@Environment(\.dismiss) private var dismiss

	let requestId: String

	private var offers: [Offer] {
		appState.offersForRequest(requestId)
			.sorted { $0.createdAt < $1.createdAt }
	}

	var body: some View {
		List {
			ForEach(offers) { offer in
				HStack {
					VStack(alignment: .leading, spacing: 4) {
						HStack {
							Text(appState.user(withId: offer.userId)?.displayName ?? "Unknown")
								.font(.subheadline)
								.fontWeight(.medium)
							if offer.isCounterOffer {
								Text("counter")
									.font(.caption2)
									.padding(.horizontal, 4)
									.padding(.vertical, 1)
									.background(.blue.opacity(0.15))
									.foregroundStyle(.blue)
									.clipShape(Capsule())
							}
						}

						Text(offer.createdAt.formatted(date: .omitted, time: .shortened))
							.font(.caption)
							.foregroundStyle(.secondary)
					}

					Spacer()

					VStack(alignment: .trailing, spacing: 4) {
						Text(offer.formattedAmount)
							.font(.headline)

						Text(offer.status.rawValue.capitalized)
							.font(.caption2)
							.fontWeight(.medium)
							.padding(.horizontal, 6)
							.padding(.vertical, 2)
							.background(statusColor(offer.status).opacity(0.15))
							.foregroundStyle(statusColor(offer.status))
							.clipShape(Capsule())
					}
				}
				.padding(.vertical, 4)
			}
		}
		.navigationTitle("Negotiation History")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Done") { dismiss() }
			}
		}
	}

	private func statusColor(_ status: OfferStatus) -> Color {
		switch status {
		case .pending: return .orange
		case .accepted: return .green
		case .declined: return .red
		case .countered: return .blue
		}
	}
}
