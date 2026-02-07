//
//  ProfileView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsProfileView: View {
	@Environment(AppState.self) private var appState
	@State private var showingSellerOnboarding = false

	private var user: User? { appState.currentUser }


	var body: some View {
		List {
			// Profile header
			Section {
				HStack(spacing: 16) {
					Circle()
						.fill(.green.opacity(0.2))
						.frame(width: 64, height: 64)
						.overlay {
							Text(user?.initials ?? "?")
								.font(.title2)
								.fontWeight(.semibold)
						}

					VStack(alignment: .leading, spacing: 4) {
						Text(user?.displayName ?? "Unknown")
							.font(.title3)
							.fontWeight(.semibold)

						Text(user?.email ?? "")
							.font(.caption)
							.foregroundStyle(.secondary)
					}
				}
				.padding(.vertical, 4)
			}

			// Stats
			Section("Stats") {
				HStack {
					statItem(
						value: user?.formattedRating ?? "—",
						label: "Rating",
						icon: "star.fill",
						color: .yellow
					)
					Divider()
					statItem(
						value: "\(user?.totalTransactions ?? 0)",
						label: "Transactions",
						icon: "arrow.left.arrow.right",
						color: .green
					)
					Divider()
					statItem(
						value: memberSince,
						label: "Member since",
						icon: "calendar",
						color: .blue
					)
				}
				.padding(.vertical, 4)
			}

			// Payments
			Section("Payments") {
				if user?.stripeOnboardingComplete == true {
					HStack {
						Label("Seller Payments", systemImage: "checkmark.circle.fill")
							.foregroundStyle(.green)
						Spacer()
						Text("Active")
							.font(.caption)
							.foregroundStyle(.green)
							.padding(.horizontal, 8)
							.padding(.vertical, 4)
							.background(.green.opacity(0.1))
							.clipShape(Capsule())
					}
				} else {
					Button {
						showingSellerOnboarding = true
					} label: {
						Label("Set Up Seller Payments", systemImage: "dollarsign.circle")
					}
				}
			}

			// Navigation
			Section {
				NavigationLink {
					ViewsTransactionHistoryView()
				} label: {
					Label("Transaction History", systemImage: "clock.arrow.circlepath")
				}

				NavigationLink {
					ViewsSettingsView()
				} label: {
					Label("Settings", systemImage: "gearshape")
				}
			}

			// Sign out
			Section {
				Button(role: .destructive) {
					appState.logout()
				} label: {
					Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
				}
			}
		}
		.navigationTitle("Profile")
		.sheet(isPresented: $showingSellerOnboarding) {
			SellerOnboardingView()
		}
	}

	private func statItem(value: String, label: String, icon: String, color: Color) -> some View {
		VStack(spacing: 4) {
			Image(systemName: icon)
				.foregroundStyle(color)
			Text(value)
				.font(.headline)
			Text(label)
				.font(.caption2)
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity)
	}

	private var memberSince: String {
		guard let date = user?.createdAt else { return "—" }
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM yyyy"
		return formatter.string(from: date)
	}
}
