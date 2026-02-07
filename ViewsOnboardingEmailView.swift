//
//  OnboardingEmailView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsOnboardingEmailView: View {
	@Environment(AppState.self) private var appState
	@Binding var onboardingStep: Int
	@Binding var email: String

	@State private var showError = false

	private var isValidEmail: Bool {
		let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluate(with: email)
	}

	var body: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: "envelope.fill")
				.font(.system(size: 48))
				.foregroundStyle(.green)

			Text("Enter your email")
				.font(.title2)
				.fontWeight(.semibold)

			Text("We'll use this to create your account and keep you in the loop.")
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal, 32)

			TextField("you@email.com", text: $email)
				.keyboardType(.emailAddress)
				.textInputAutocapitalization(.never)
				.textContentType(.emailAddress)
				.autocorrectionDisabled()
				.padding()
				.background(Color.gray.opacity(0.12))
				.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
				.padding(.horizontal, Constants.UI.largePadding)
				.onChange(of: email) {
					showError = false
				}

			if showError {
				Text("Please enter a valid email address")
					.foregroundStyle(.red)
					.font(.caption)
			}

			Spacer()

			Button {
				if isValidEmail {
					withAnimation { onboardingStep = 2 }
				} else {
					showError = true
				}
			} label: {
				Text("Continue")
					.font(.headline)
					.frame(maxWidth: .infinity)
					.frame(height: Constants.UI.buttonHeight)
			}
			.buttonStyle(.borderedProminent)
			.tint(.green)
			.padding(.horizontal, Constants.UI.largePadding)

			Button("Back") {
				withAnimation { onboardingStep = 0 }
			}
			.font(.subheadline)
			.foregroundStyle(.secondary)

			Spacer().frame(height: 24)
		}
	}
}
