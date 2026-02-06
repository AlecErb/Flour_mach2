//
//  RequestCard.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI
import CoreLocation

struct SharedRequestCard: View {
	let request: Request
	var userLocation: CLLocationCoordinate2D?
	var requesterName: String?

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				urgencyBadge
				Spacer()
				Text(request.formattedPrice)
					.font(.headline)
					.foregroundStyle(.green)
			}

			Text(request.itemDescription)
				.font(.body)
				.lineLimit(2)

			HStack(spacing: 12) {
				if let name = requesterName {
					Label(name, systemImage: "person.fill")
						.font(.caption)
						.foregroundStyle(.secondary)
				}

				if let loc = userLocation {
					Label(request.formattedDistance(from: loc), systemImage: "location.fill")
						.font(.caption)
						.foregroundStyle(.secondary)
				}

				Label(request.formattedTimeRemaining, systemImage: "clock")
					.font(.caption)
					.foregroundStyle(.secondary)

				Spacer()

				statusBadge
			}
		}
		.padding()
		.background(Color(.systemBackground))
		.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
		.shadow(color: .black.opacity(0.05), radius: 4, y: 2)
	}

	private var urgencyBadge: some View {
		HStack(spacing: 4) {
			Image(systemName: urgencyIcon)
				.font(.caption2)
			Text(request.urgency.displayName)
				.font(.caption)
				.fontWeight(.medium)
		}
		.padding(.horizontal, 8)
		.padding(.vertical, 4)
		.background(urgencyColor.opacity(0.15))
		.foregroundStyle(urgencyColor)
		.clipShape(Capsule())
	}

	private var statusBadge: some View {
		Text(request.status.rawValue.capitalized)
			.font(.caption2)
			.fontWeight(.medium)
			.padding(.horizontal, 6)
			.padding(.vertical, 2)
			.background(statusColor.opacity(0.15))
			.foregroundStyle(statusColor)
			.clipShape(Capsule())
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

	private var statusColor: Color {
		switch request.status {
		case .open: return .green
		case .negotiating: return .orange
		case .matched: return .blue
		case .completed: return .gray
		case .cancelled: return .red
		case .expired: return .gray
		}
	}
}
