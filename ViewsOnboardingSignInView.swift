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
						// Parse Firebase error and show friendly message
						let errorString = error.localizedDescription.lowercased()
						if errorString.contains("user not found") || errorString.contains("no user record") {
							errorMessage = "Account not found. Please sign up first."
						} else if errorString.contains("wrong password") || errorString.contains("invalid credential") {
							errorMessage = "Incorrect password. Please try again."
						} else if errorString.contains("malformed") || errorString.contains("invalid-email") {
							errorMessage = "Invalid email format. Please check your email."
						} else if errorString.contains("network") {
							errorMessage = "Network error. Please check your connection."
						} else {
							errorMessage = "Sign in failed. Please check your credentials or sign up."
						}
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

			HStack(spacing: 4) {
				Text("Don't have an account?")
					.font(.subheadline)
					.foregroundStyle(.secondary)

				Button("Sign Up") {
					withAnimation { onboardingStep = 1 }
				}
				.font(.subheadline)
				.fontWeight(.semibold)
			}

			Button("Back") {
				withAnimation { onboardingStep = 0 }
			}
			.font(.subheadline)
			.foregroundStyle(.secondary)

			Spacer().frame(height: 24)
		}
	}
}
