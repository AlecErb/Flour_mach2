//
//  FeeBreakdownView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct SharedFeeBreakdownView: View {
	let itemPrice: Double

	private var platformFee: Double {
		Transaction.calculatePlatformFee(for: itemPrice)
	}

	private var total: Double {
		itemPrice + platformFee
	}

	var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("Item price")
					.foregroundStyle(.secondary)
				Spacer()
				Text(String(format: "$%.2f", itemPrice))
			}
			.font(.subheadline)

			HStack {
				Text("Platform fee (10%, max $2)")
					.foregroundStyle(.secondary)
				Spacer()
				Text(String(format: "$%.2f", platformFee))
			}
			.font(.subheadline)

			Divider()

			HStack {
				Text("Total")
					.fontWeight(.semibold)
				Spacer()
				Text(String(format: "$%.2f", total))
					.fontWeight(.semibold)
			}
			.font(.subheadline)
		}
		.padding()
		.background(Color.gray.opacity(0.12))
		.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
	}
}
