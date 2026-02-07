//
//  OnboardingProfileSetupView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsOnboardingProfileSetupView: View {
	@Environment(AppState.self) private var appState
	@Binding var onboardingStep: Int
	let email: String

	@State private var displayName = ""
	@State private var phone = ""
	@State private var password = ""
	@State private var confirmPassword = ""
	@State private var isLoading = false
	@State private var errorMessage: String?

	private var isValid: Bool {
		displayName.count >= Constants.Validation.minDisplayNameLength &&
		displayName.count <= Constants.Validation.maxDisplayNameLength &&
		phone.count >= 7 &&
		password.count >= 6 &&
		password == confirmPassword
	}

	private var passwordMismatch: Bool {
		!confirmPassword.isEmpty && password != confirmPassword
	}

	var body: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: "person.crop.circle.fill")
				.font(.system(size: 48))
				.foregroundStyle(.green)

			Text("Set up your profile")
				.font(.title2)
				.fontWeight(.semibold)

			VStack(spacing: 16) {
				VStack(alignment: .leading, spacing: 4) {
					Text("Display Name")
						.font(.caption)
						.foregroundStyle(.secondary)
					TextField("What should people call you?", text: $displayName)
						.textContentType(.name)
						.padding()
						.background(Color.gray.opacity(0.12))
						.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
				}

				VStack(alignment: .leading, spacing: 4) {
					Text("Phone Number")
						.font(.caption)
						.foregroundStyle(.secondary)
					TextField("(555) 123-4567", text: $phone)
						.keyboardType(.phonePad)
						.textContentType(.telephoneNumber)
						.padding()
						.background(Color.gray.opacity(0.12))
						.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
				}

				VStack(alignment: .leading, spacing: 4) {
					Text("Password (6+ characters)")
						.font(.caption)
						.foregroundStyle(.secondary)
					SecureField("Create a password", text: $password)
						.textContentType(.newPassword)
						.padding()
						.background(Color.gray.opacity(0.12))
						.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
				}

				VStack(alignment: .leading, spacing: 4) {
					Text("Confirm Password")
						.font(.caption)
						.foregroundStyle(.secondary)
					SecureField("Re-enter password", text: $confirmPassword)
						.textContentType(.newPassword)
						.padding()
						.background(Color.gray.opacity(0.12))
						.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
				}

				if passwordMismatch {
					Text("Passwords don't match")
						.foregroundStyle(.red)
						.font(.caption)
				}
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
				guard isValid else {
					errorMessage = "Please fill in all fields correctly"
					return
				}
				Task {
					isLoading = true
					errorMessage = nil
					await appState.signUp(
						email: email,
						password: password,
						displayName: displayName,
						phone: phone
					)
					if let error = appState.authError {
						errorMessage = error
					}
					isLoading = false
				}
			} label: {
				if isLoading {
					ProgressView()
						.frame(maxWidth: .infinity)
						.frame(height: Constants.UI.buttonHeight)
				} else {
					Text("Create Account")
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
				withAnimation { onboardingStep = 1 }
			}
			.font(.subheadline)
			.foregroundStyle(.secondary)

			Spacer().frame(height: 24)
		}
	}
}
