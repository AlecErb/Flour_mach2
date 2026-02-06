//
//  TransactionHistoryView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsTransactionHistoryView: View {
	@Environment(AppState.self) private var appState

	private var userId: String { appState.currentUser?.id ?? "" }

	private var allTransactions: [Transaction] {
		appState.myTransactions(userId: userId)
			.sorted { $0.createdAt > $1.createdAt }
	}

	var body: some View {
		List {
			if allTransactions.isEmpty {
				ContentUnavailableView(
					"No transactions yet",
					systemImage: "clock.arrow.circlepath",
					description: Text("Your completed transactions will appear here.")
				)
			} else {
				ForEach(allTransactions) { transaction in
					transactionRow(transaction)
				}
			}
		}
		.navigationTitle("Transaction History")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func transactionRow(_ transaction: Transaction) -> some View {
		let request = appState.requests.first { $0.id == transaction.requestId }
		let otherUserId = transaction.requesterId == userId ? transaction.fulfillerId : transaction.requesterId
		let otherUser = appState.user(withId: otherUserId)
		let isRequester = transaction.requesterId == userId

		return HStack {
			VStack(alignment: .leading, spacing: 4) {
				Text(request?.itemDescription ?? "Unknown item")
					.font(.subheadline)
					.fontWeight(.medium)

				HStack(spacing: 8) {
					Text(isRequester ? "Requested from" : "Delivered to")
						.font(.caption)
						.foregroundStyle(.secondary)
					Text(otherUser?.displayName ?? "Unknown")
						.font(.caption)
						.fontWeight(.medium)
				}

				if let date = transaction.completedAt {
					Text(date.formatted(date: .abbreviated, time: .shortened))
						.font(.caption2)
						.foregroundStyle(.secondary)
				} else {
					Text(transaction.createdAt.formatted(date: .abbreviated, time: .shortened))
						.font(.caption2)
						.foregroundStyle(.secondary)
				}
			}

			Spacer()

			VStack(alignment: .trailing, spacing: 4) {
				Text(transaction.formattedTotal)
					.font(.subheadline)
					.fontWeight(.semibold)

				Text(transaction.status.rawValue.capitalized)
					.font(.caption2)
					.fontWeight(.medium)
					.padding(.horizontal, 6)
					.padding(.vertical, 2)
					.background(statusColor(transaction.status).opacity(0.15))
					.foregroundStyle(statusColor(transaction.status))
					.clipShape(Capsule())
			}
		}
		.padding(.vertical, 4)
	}

	private func statusColor(_ status: TransactionStatus) -> Color {
		switch status {
		case .pending: return .orange
		case .completed: return .green
		case .disputed: return .red
		case .refunded: return .gray
		}
	}
}
