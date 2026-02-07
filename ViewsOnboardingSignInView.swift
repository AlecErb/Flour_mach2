//
//  OnboardingSignInView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsOnboardingSignInView: View {
	@Environment(AppState.self) private var appState
	@Binding var onboardingStep: Int

	@State private var email = ""
	@State private var password = ""
	@State private var isLoading = false
	@State private var errorMessage: String?

	private var isValid: Bool {
		!email.isEmpty && password.count >= 6
	}

	var body: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: "person.crop.circle.badge.checkmark")
				.font(.system(size: 48))
				.foregroundStyle(.green)

			Text("Welcome back")
				.font(.title2)
				.fontWeight(.semibold)

			VStack(spacing: 16) {
				TextField("Email", text: $email)
					.keyboardType(.emailAddress)
					.textInputAutocapitalization(.never)
					.textContentType(.emailAddress)
					.autocorrectionDisabled()
					.padding()
					.background(Color.gray.opacity(0.12))
					.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))

				SecureField("Password", text: $password)
					.textContentType(.password)
					.padding()
					.background(Color.gray.opacity(0.12))
					.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
			}
			.padding(.horizontal, Constants.UI.largePadding)

			if let error = errorMessage {
				Text(error)
					.foregroundStyle(.red)
					.font(.caption)
					.multilineTextAlignment(.center)
					.padding(.horizontal, Constants.UI.largePadding)
			}

			Spacer()

			Button {
				Task {
					isLoading = true
					errorMessage = nil
					do {
						try await appState.signIn(email: email, password: password)
					} catch {
						errorMessage = error.localizedDescription
					}
					isLoading = false
				}
			} label: {
				if isLoading {
					ProgressView()
						.frame(maxWidth: .infinity)
						.frame(height: Constants.UI.buttonHeight)
				} else {
					Text("Sign In")
						.font(.headline)
						.frame(maxWidth: .infinity)
						.frame(height: Constants.UI.buttonHeight)
				}
			}
			.buttonStyle(.borderedProminent)
			.tint(.green)
			.disabled(!isValid || isLoading)
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
