//
//  SellerOnboardingView.swift
//  Flour
//
//  Stripe seller onboarding flow
//

import SwiftUI

struct SellerOnboardingView: View {
	@Environment(AppState.self) private var appState
	@Environment(\.dismiss) private var dismiss

	@State private var isLoading = false
	@State private var errorMessage: String?
	@State private var showingOnboarding = false
	@State private var onboardingURL: URL?

	var body: some View {
		VStack(spacing: 24) {
			// Header
			VStack(spacing: 12) {
				Image(systemName: "dollarsign.circle.fill")
					.font(.system(size: 64))
					.foregroundStyle(.green)

				Text("Become a Seller")
					.font(.title2)
					.fontWeight(.bold)

				Text("Set up payments to start fulfilling requests and earning money.")
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
					.padding(.horizontal)
			}
			.padding(.top, 48)

			// Benefits
			VStack(alignment: .leading, spacing: 16) {
				benefitRow(icon: "clock.fill", text: "Get paid daily")
				benefitRow(icon: "shield.fill", text: "Secure payments via Stripe")
				benefitRow(icon: "chart.line.uptrend.xyaxis", text: "Earn money helping others")
			}
			.padding(.horizontal, 32)

			Spacer()

			// Setup button
			Button {
				setupSellerAccount()
			} label: {
				if isLoading {
					ProgressView()
						.progressViewStyle(.circular)
						.tint(.white)
				} else {
					Text("Set Up Payments")
						.fontWeight(.semibold)
				}
			}
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.disabled(isLoading)

			if let error = errorMessage {
				Text(error)
					.font(.caption)
					.foregroundStyle(.red)
					.multilineTextAlignment(.center)
					.padding(.horizontal)
			}

			Button("Maybe Later") {
				dismiss()
			}
			.foregroundStyle(.secondary)
			.padding(.bottom, 32)
		}
		.sheet(isPresented: $showingOnboarding) {
			if let url = onboardingURL {
				SafariView(url: url) {
					// Callback when user returns from Stripe onboarding
					checkOnboardingStatus()
				}
			}
		}
	}

	private func benefitRow(icon: String, text: String) -> some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.font(.title3)
				.foregroundStyle(.blue)
				.frame(width: 32)

			Text(text)
				.font(.body)
		}
	}

	private func setupSellerAccount() {
		Task {
			isLoading = true
			errorMessage = nil

			do {
				let url = try await appState.setupSellerAccount()
				onboardingURL = url
				showingOnboarding = true
			} catch {
				errorMessage = error.localizedDescription
			}

			isLoading = false
		}
	}

	private func checkOnboardingStatus() {
		Task {
			do {
				let isComplete = try await appState.checkSellerStatus()
				if isComplete {
					dismiss()
				} else {
					errorMessage = "Onboarding not complete. Please finish setup in Stripe."
				}
			} catch {
				errorMessage = "Could not verify onboarding status"
			}
		}
	}
}

// Simple Safari view wrapper
struct SafariView: View {
	let url: URL
	let onDismiss: () -> Void

	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			VStack {
				Text("Complete Stripe Setup")
					.font(.headline)
					.padding()

				Text("You'll be redirected to Stripe to complete your account setup. This is secure and managed by Stripe.")
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
					.padding(.horizontal)

				Spacer()

				Link(destination: url) {
					Text("Open Stripe Setup")
						.fontWeight(.semibold)
				}
				.buttonStyle(.borderedProminent)
				.controlSize(.large)

				Spacer()
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Done") {
						dismiss()
						onDismiss()
					}
				}
			}
		}
	}
}

#Preview {
	SellerOnboardingView()
		.environment(AppState())
}
