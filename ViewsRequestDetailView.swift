//
//  RequestDetailView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsRequestDetailView: View {
	@Environment(AppState.self) private var appState
	@Environment(LocationService.self) private var locationService

	let request: Request

	@State private var showOfferSheet = false
	@State private var showNegotiationHistory = false

	private var isRequester: Bool {
		request.requesterId == appState.currentUser?.id
	}

	private var requester: User? {
		appState.user(withId: request.requesterId)
	}

	private var requestOffers: [Offer] {
		appState.offersForRequest(request.id)
			.sorted { $0.createdAt > $1.createdAt }
	}

	private var latestRequest: Request {
		appState.requests.first { $0.id == request.id } ?? request
	}

	private var transaction: Transaction? {
		appState.transaction(forRequestId: request.id)
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				// Header
				VStack(alignment: .leading, spacing: 8) {
					HStack {
						urgencyBadge
						Spacer()
						Text(request.formattedPrice)
							.font(.title2)
							.fontWeight(.bold)
							.foregroundStyle(.green)
					}

					Text(request.itemDescription)
						.font(.title3)
						.fontWeight(.medium)
				}

				Divider()

				// Details
				VStack(spacing: 12) {
					detailRow("Requester", value: requester?.displayName ?? "Unknown", icon: "person.fill")
					detailRow("Distance", value: request.formattedDistance(from: locationService.currentLocation), icon: "location.fill")
					detailRow("Time left", value: request.formattedTimeRemaining, icon: "clock")
					detailRow("Radius", value: "\(Int(request.radiusMeters))m", icon: "circle.dashed")
				}

				Divider()

				// Fee breakdown
				SharedFeeBreakdownView(itemPrice: request.offerPrice)

				// Offers section
				if !requestOffers.isEmpty {
					Divider()

					VStack(alignment: .leading, spacing: 8) {
						HStack {
							Text("Offers (\(requestOffers.count))")
								.font(.headline)
							Spacer()
							if requestOffers.count > 1 {
								Button("History") { showNegotiationHistory = true }
									.font(.caption)
							}
						}

						ForEach(requestOffers.prefix(3)) { offer in
							offerRow(offer)
						}
					}
				}

				Spacer(minLength: 80)
			}
			.padding()
		}
		.navigationTitle("Request Details")
		.navigationBarTitleDisplayMode(.inline)
		.safeAreaInset(edge: .bottom) {
			actionButtons
		}
		.sheet(isPresented: $showOfferSheet) {
			NavigationStack {
				ViewsOfferSheet(request: request)
			}
			.presentationDetents([.medium])
		}
		.sheet(isPresented: $showNegotiationHistory) {
			NavigationStack {
				ViewsNegotiationHistoryView(requestId: request.id)
			}
		}
	}

	@ViewBuilder
	private var actionButtons: some View {
		let current = latestRequest

		VStack(spacing: 8) {
			if current.status == .matched, let txn = transaction {
				// Show pay button if requester hasn't paid yet
				if isRequester && txn.paymentStatus != "succeeded" {
					NavigationLink {
						PaymentView(transaction: txn)
					} label: {
						Label("Pay Now", systemImage: "creditcard.fill")
							.font(.headline)
							.frame(maxWidth: .infinity)
							.frame(height: Constants.UI.buttonHeight)
					}
					.buttonStyle(.borderedProminent)
					.tint(.blue)
				}

				// Chat button (always available once matched)
				NavigationLink(value: txn) {
					Label("Open Chat", systemImage: "message.fill")
						.font(.headline)
						.frame(maxWidth: .infinity)
						.frame(height: Constants.UI.buttonHeight)
				}
				.buttonStyle(.borderedProminent)
				.tint(.green)
			} else if !isRequester && current.isActive {
				Button {
					showOfferSheet = true
				} label: {
					Text("Make an Offer")
						.font(.headline)
						.frame(maxWidth: .infinity)
						.frame(height: Constants.UI.buttonHeight)
				}
				.buttonStyle(.borderedProminent)
				.tint(.green)
			} else if isRequester && current.isActive {
				// Show pending offers for requester to accept/decline
				if let pendingOffer = requestOffers.first(where: { $0.isPending }) {
					HStack(spacing: 12) {
						Button {
							appState.declineOffer(pendingOffer.id)
						} label: {
							Text("Decline")
								.font(.headline)
								.frame(maxWidth: .infinity)
								.frame(height: Constants.UI.buttonHeight)
						}
						.buttonStyle(.bordered)

						Button {
							appState.acceptOffer(pendingOffer.id)
						} label: {
							Text("Accept \(pendingOffer.formattedAmount)")
								.font(.headline)
								.frame(maxWidth: .infinity)
								.frame(height: Constants.UI.buttonHeight)
						}
						.buttonStyle(.borderedProminent)
						.tint(.green)
					}
				}
			}
		}
		.padding()
		.background(.ultraThinMaterial)
	}

	private func detailRow(_ label: String, value: String, icon: String) -> some View {
		HStack {
			Label(label, systemImage: icon)
				.foregroundStyle(.secondary)
				.font(.subheadline)
			Spacer()
			Text(value)
				.font(.subheadline)
				.fontWeight(.medium)
		}
	}

	private var urgencyBadge: some View {
		HStack(spacing: 4) {
			Image(systemName: urgencyIcon)
			Text(request.urgency.displayName)
				.fontWeight(.medium)
		}
		.font(.subheadline)
		.padding(.horizontal, 10)
		.padding(.vertical, 6)
		.background(urgencyColor.opacity(0.15))
		.foregroundStyle(urgencyColor)
		.clipShape(Capsule())
	}

	private func offerRow(_ offer: Offer) -> some View {
		let offerUser = appState.user(withId: offer.userId)

		return HStack {
			Text(offerUser?.displayName ?? "Unknown")
				.font(.subheadline)
			if offer.isCounterOffer {
				Text("(counter)")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			Spacer()
			Text(offer.formattedAmount)
				.font(.subheadline)
				.fontWeight(.semibold)
			Text(offer.status.rawValue.capitalized)
				.font(.caption2)
				.padding(.horizontal, 6)
				.padding(.vertical, 2)
				.background(offerStatusColor(offer.status).opacity(0.15))
				.foregroundStyle(offerStatusColor(offer.status))
				.clipShape(Capsule())
		}
		.padding(.vertical, 4)
	}

	private var urgencyIcon: String {
		switch request.urgency {
		case .asap: return "bolt.fill"
		case .thirtyMinutes: return "clock.fill"
		case .oneHour: return "clock"
		case .flexible: return "leaf.fill"
		}
	}

	private var urgencyColor: Color {
		switch request.urgency {
		case .asap: return .red
		case .thirtyMinutes: return .orange
		case .oneHour: return .blue
		case .flexible: return .green
		}
	}

	private func offerStatusColor(_ status: OfferStatus) -> Color {
		switch status {
		case .pending: return .orange
		case .accepted: return .green
		case .declined: return .red
		case .countered: return .blue
		}
	}
}
