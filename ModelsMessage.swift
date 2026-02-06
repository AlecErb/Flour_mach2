//
//  Message.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation

/// Represents a chat message between requester and fulfiller
struct Message: Identifiable, Codable, Hashable {
    let id: String
    let transactionId: String
    let senderId: String
    var content: String
    let createdAt: Date
    var isRead: Bool
    
    var isUnread: Bool {
        return !isRead
    }
    
    /// Formatted timestamp
    var formattedTime: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(createdAt) {
            formatter.dateFormat = "h:mm a"
        } else if calendar.isDateInYesterday(createdAt) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "MMM d"
        }
        
        return formatter.string(from: createdAt)
    }
    
    init(
        id: String = UUID().uuidString,
        transactionId: String,
        senderId: String,
        content: String,
        createdAt: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.transactionId = transactionId
        self.senderId = senderId
        self.content = content
        self.createdAt = createdAt
        self.isRead = isRead
    }
}

// MARK: - Extensions

extension Message {
    /// Check if message is from a specific user
    func isFrom(_ userId: String) -> Bool {
        return senderId == userId
    }
    
    /// Mark message as read
    mutating func markAsRead() {
        isRead = true
    }
}

// MARK: - Message Preview

extension Message {
    /// Get a preview of the message content (truncated)
    func preview(maxLength: Int = 50) -> String {
        if content.count <= maxLength {
            return content
        }
        let index = content.index(content.startIndex, offsetBy: maxLength)
        return String(content[..<index]) + "..."
    }
}
