//
//  OnboardingWelcomeView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsOnboardingWelcomeView: View {
	@Binding var onboardingStep: Int

	var body: some View {
		VStack(spacing: 32) {
			Spacer()

			Image(systemName: "leaf.fill")
				.font(.system(size: 80))
				.foregroundStyle(.green)

			VStack(spacing: 8) {
				Text("Flour")
					.font(.largeTitle)
					.fontWeight(.bold)

				Text("Hyperlocal campus marketplace")
					.font(.title3)
					.foregroundStyle(.secondary)
			}

			Text("Need something? Someone nearby probably has it. Post a request and get it delivered in minutes.")
				.font(.body)
				.multilineTextAlignment(.center)
				.foregroundStyle(.secondary)
				.padding(.horizontal, 32)

			Spacer()

			Button {
				withAnimation { onboardingStep = 1 }
			} label: {
				Text("Get Started")
					.font(.headline)
					.frame(maxWidth: .infinity)
					.frame(height: Constants.UI.buttonHeight)
			}
			.buttonStyle(.borderedProminent)
			.tint(.green)
			.padding(.horizontal, Constants.UI.largePadding)

			Button("Skip — Use Demo Account") {
				// Handled by parent
				onboardingStep = -1
			}
			.font(.subheadline)
			.foregroundStyle(.secondary)

			Spacer().frame(height: 24)
		}
	}
}
