//
//  ChatListView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsChatListView: View {
	@Environment(AppState.self) private var appState

	private var userId: String { appState.currentUser?.id ?? "" }

	private var chats: [(Transaction, Message?)] {
		appState.activeTransactionsWithMessages()
	}

	var body: some View {
		Group {
			if chats.isEmpty {
				ContentUnavailableView(
					"No conversations",
					systemImage: "message",
					description: Text("Accept an offer to start chatting.")
				)
			} else {
				List {
					ForEach(chats, id: \.0.id) { (transaction, lastMessage) in
						NavigationLink(value: transaction) {
							chatRow(transaction: transaction, lastMessage: lastMessage)
						}
					}
				}
			}
		}
		.navigationTitle("Messages")
		.navigationDestination(for: Transaction.self) { transaction in
			ViewsChatView(transaction: transaction)
		}
	}

	private func chatRow(transaction: Transaction, lastMessage: Message?) -> some View {
		let otherUserId = transaction.requesterId == userId ? transaction.fulfillerId : transaction.requesterId
		let otherUser = appState.user(withId: otherUserId)
		let unread = appState.unreadCount(forTransaction: transaction.id)

		return HStack(spacing: 12) {
			Circle()
				.fill(.green.opacity(0.2))
				.frame(width: 48, height: 48)
				.overlay {
					Text(otherUser?.initials ?? "?")
						.fontWeight(.medium)
				}

			VStack(alignment: .leading, spacing: 2) {
				HStack {
					Text(otherUser?.displayName ?? "Unknown")
						.font(.subheadline)
						.fontWeight(.medium)
					Spacer()
					if let msg = lastMessage {
						Text(msg.formattedTime)
							.font(.caption2)
							.foregroundStyle(.secondary)
					}
				}

				HStack {
					Text(lastMessage?.preview() ?? "No messages yet")
						.font(.caption)
						.foregroundStyle(.secondary)
						.lineLimit(1)
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
		}
	}
}
