//
//  ChatView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsChatView: View {
	@Environment(AppState.self) private var appState
	@Environment(\.dismiss) private var dismiss

	let transaction: Transaction

	@State private var messageText = ""
	@State private var showCompletion = false

	private var userId: String { appState.currentUser?.id ?? "" }

	private var chatMessages: [Message] {
		appState.messages(forTransaction: transaction.id)
	}

	private var otherUserId: String {
		transaction.requesterId == userId ? transaction.fulfillerId : transaction.requesterId
	}

	private var otherUser: User? {
		appState.user(withId: otherUserId)
	}

	private var currentTransaction: Transaction {
		appState.transactions.first { $0.id == transaction.id } ?? transaction
	}

	var body: some View {
		VStack(spacing: 0) {
			// Messages
			ScrollViewReader { proxy in
				ScrollView {
					LazyVStack(spacing: 8) {
						ForEach(chatMessages) { message in
							messageBubble(message)
								.id(message.id)
						}
					}
					.padding()
				}
				.onChange(of: chatMessages.count) {
					if let last = chatMessages.last {
						withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
					}
				}
			}

			Divider()

			// Input
			HStack(spacing: 12) {
				TextField("Message...", text: $messageText)
					.textFieldStyle(.roundedBorder)

				Button {
					let text = messageText.trimmingCharacters(in: .whitespaces)
					guard !text.isEmpty else { return }
					appState.sendMessage(transactionId: transaction.id, content: text)
					messageText = ""
				} label: {
					Image(systemName: "arrow.up.circle.fill")
						.font(.title2)
						.foregroundStyle(.green)
				}
				.disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
			}
			.padding()
		}
		.navigationTitle(otherUser?.displayName ?? "Chat")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				if currentTransaction.isPending {
					Button("Complete") { showCompletion = true }
						.fontWeight(.semibold)
						.foregroundStyle(.green)
				}
			}
		}
		.sheet(isPresented: $showCompletion) {
			NavigationStack {
				ViewsCompletionView(transaction: transaction)
			}
		}
		.onAppear {
			appState.markMessagesRead(transactionId: transaction.id)
		}
	}

	private func messageBubble(_ message: Message) -> some View {
		let isMe = message.senderId == userId

		return HStack {
			if isMe { Spacer(minLength: 60) }

			VStack(alignment: isMe ? .trailing : .leading, spacing: 2) {
				Text(message.content)
					.font(.body)
					.padding(.horizontal, 12)
					.padding(.vertical, 8)
					.background(isMe ? Color.green : Color.gray.opacity(0.15))
					.foregroundStyle(isMe ? .white : .primary)
					.clipShape(RoundedRectangle(cornerRadius: 16))

				Text(message.formattedTime)
					.font(.caption2)
					.foregroundStyle(.secondary)
			}

			if !isMe { Spacer(minLength: 60) }
		}
	}
}
