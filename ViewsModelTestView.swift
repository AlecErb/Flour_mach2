//
//  ModelTestView.swift
//  Flour
//
//  Created on 2026-02-06.
//
//  A test view to demonstrate that all models are working correctly.
//  This can be displayed in ContentView to verify Phase 2 is complete.

import SwiftUI

struct ModelTestView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Current User") {
                    UserRow(user: MockData.currentUser)
                }
                
                Section("Active Requests") {
                    ForEach(MockData.activeRequests) { request in
                        RequestRow(request: request)
                    }
                }
                
                Section("Transaction Details") {
                    TransactionRow(transaction: MockData.transaction1)
                }
                
                Section("Platform Fee Examples") {
                    FeeExampleRow(itemPrice: 3.00)
                    FeeExampleRow(itemPrice: 5.00)
                    FeeExampleRow(itemPrice: 10.00)
                    FeeExampleRow(itemPrice: 20.00)
                    FeeExampleRow(itemPrice: 30.00)
                }
            }
            .navigationTitle("Phase 2: Models ✓")
        }
    }
}

// MARK: - Row Components

struct UserRow: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.displayName)
                .font(.headline)
            Text(user.email)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack {
                Text("Rating: \(user.formattedRating)")
                Text("•")
                Text("\(user.totalTransactions) transactions")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}

struct RequestRow: View {
    let request: Request
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(request.itemDescription)
                .font(.headline)
            HStack {
                Text(request.formattedPrice)
                    .foregroundStyle(.green)
                Text("•")
                Text(request.urgency.displayName)
                Text("•")
                Text(request.status.rawValue)
                    .textCase(.uppercase)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            if !request.isExpired {
                Text("Expires in: \(request.formattedTimeRemaining)")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Item Price:")
                Spacer()
                Text(transaction.formattedItemPrice)
            }
            HStack {
                Text("Platform Fee:")
                Spacer()
                Text(transaction.formattedPlatformFee)
            }
            Divider()
            HStack {
                Text("Total:")
                    .fontWeight(.semibold)
                Spacer()
                Text(transaction.formattedTotal)
                    .fontWeight(.semibold)
            }
            
            HStack {
                Label(
                    transaction.requesterConfirmed ? "Confirmed" : "Pending",
                    systemImage: transaction.requesterConfirmed ? "checkmark.circle.fill" : "circle"
                )
                .font(.caption)
                .foregroundStyle(transaction.requesterConfirmed ? .green : .secondary)
                
                Spacer()
                
                Label(
                    transaction.fulfillerConfirmed ? "Confirmed" : "Pending",
                    systemImage: transaction.fulfillerConfirmed ? "checkmark.circle.fill" : "circle"
                )
                .font(.caption)
                .foregroundStyle(transaction.fulfillerConfirmed ? .green : .secondary)
            }
            .padding(.top, 4)
        }
    }
}

struct FeeExampleRow: View {
    let itemPrice: Double
    
    var platformFee: Double {
        Transaction.calculatePlatformFee(for: itemPrice)
    }
    
    var total: Double {
        Transaction.calculateTotal(for: itemPrice)
    }
    
    var body: some View {
        HStack {
            Text(String(format: "$%.2f item", itemPrice))
            Spacer()
            Text(String(format: "$%.2f fee", platformFee))
                .foregroundStyle(.secondary)
            Text("→")
                .foregroundStyle(.secondary)
            Text(String(format: "$%.2f total", total))
                .fontWeight(.semibold)
        }
        .font(.callout)
    }
}

// MARK: - Preview

#Preview {
    ModelTestView()
}
