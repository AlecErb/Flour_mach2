//
//  ActivityView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsActivityView: View {
	@Environment(AppState.self) private var appState

	private var userId: String { appState.currentUser?.id ?? "" }

	private var myRequests: [Request] {
		appState.myRequests(userId: userId)
			.sorted { $0.createdAt > $1.createdAt }
	}

	private var myTransactions: [Transaction] {
		appState.myTransactions(userId: userId)
			.sorted { $0.createdAt > $1.createdAt }
	}

	private var pendingTransactions: [Transaction] {
		myTransactions.filter { $0.isPending }
	}

	private var completedTransactions: [Transaction] {
		myTransactions.filter { $0.isCompleted }
	}

	var body: some View {
		List {
			// Active chats section
			if !pendingTransactions.isEmpty {
				Section("Active") {
					ForEach(pendingTransactions) { transaction in
						NavigationLink(value: transaction) {
							activeTransactionRow(transaction)
						}
					}
				}
			}

			// My requests section
			Section("My Requests") {
				if myRequests.isEmpty {
					Text("No requests yet")
						.foregroundStyle(.secondary)
				} else {
					ForEach(myRequests) { request in
						NavigationLink(value: request) {
							requestRow(request)
						}
					}
				}
			}

			// Completed section
			if !completedTransactions.isEmpty {
				Section("Completed") {
					ForEach(completedTransactions.prefix(5)) { transaction in
						completedTransactionRow(transaction)
					}

					if completedTransactions.count > 5 {
						NavigationLink("See all") {
							ViewsTransactionHistoryView()
						}
					}
				}
			}
		}
		.navigationTitle("Activity")
		.navigationDestination(for: Request.self) { request in
			ViewsRequestDetailView(request: request)
		}
		.navigationDestination(for: Transaction.self) { transaction in
			ViewsChatView(transaction: transaction)
		}
	}

	private func activeTransactionRow(_ transaction: Transaction) -> some View {
		let otherUserId = transaction.requesterId == userId ? transaction.fulfillerId : transaction.requesterId
		let otherUser = appState.user(withId: otherUserId)
		let lastMessage = appState.messages(forTransaction: transaction.id).last
		let unread = appState.unreadCount(forTransaction: transaction.id)

		return HStack {
			Circle()
				.fill(.green.opacity(0.2))
				.frame(width: 44, height: 44)
				.overlay {
					Text(otherUser?.initials ?? "?")
						.font(.subheadline)
						.fontWeight(.medium)
				}

			VStack(alignment: .leading, spacing: 2) {
				Text(otherUser?.displayName ?? "Unknown")
					.font(.subheadline)
					.fontWeight(.medium)
				if let msg = lastMessage {
					Text(msg.preview())
						.font(.caption)
						.foregroundStyle(.secondary)
						.lineLimit(1)
				}
			}

			Spacer()

			if unread > 0 {
				Text("\(unread)")
					.font(.caption2)
					.fontWeight(.bold)
					.foregroundStyle(.white)
					.padding(.horizontal, 6)
					.padding(.vertical, 2)
					.background(.green)
					.clipShape(Capsule())
			}
		}
	}

	private func requestRow(_ request: Request) -> some View {
		HStack {
			VStack(alignment: .leading, spacing: 2) {
				Text(request.itemDescription)
					.font(.subheadline)
					.lineLimit(1)
				Text(request.formattedPrice)
					.font(.caption)
					.foregroundStyle(.green)
			}

			Spacer()

			Text(request.status.rawValue.capitalized)
				.font(.caption2)
				.fontWeight(.medium)
				.padding(.horizontal, 6)
				.padding(.vertical, 2)
				.background(statusColor(request.status).opacity(0.15))
				.foregroundStyle(statusColor(request.status))
				.clipShape(Capsule())
		}
	}

	private func completedTransactionRow(_ transaction: Transaction) -> some View {
		HStack {
			VStack(alignment: .leading, spacing: 2) {
				if let request = appState.requests.first(where: { $0.id == transaction.requestId }) {
					Text(request.itemDescription)
						.font(.subheadline)
						.lineLimit(1)
				}
				Text(transaction.formattedTotal)
					.font(.caption)
					.foregroundStyle(.secondary)
			}

			Spacer()

			Image(systemName: "checkmark.circle.fill")
				.foregroundStyle(.green)
		}
	}

	private func statusColor(_ status: RequestStatus) -> Color {
		switch status {
		case .open: return .green
		case .negotiating: return .orange
		case .matched: return .blue
		case .completed: return .gray
		case .cancelled: return .red
		case .expired: return .gray
		}
	}
}
