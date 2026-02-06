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
	@Binding var detectedSchool: School?

	@State private var showError = false

	private var isValidEmail: Bool {
		let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.edu"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluate(with: email)
	}

	var body: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: "envelope.fill")
				.font(.system(size: 48))
				.foregroundStyle(.green)

			Text("Enter your .edu email")
				.font(.title2)
				.fontWeight(.semibold)

			Text("We use your school email to verify you're a student and connect you with your campus.")
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal, 32)

			TextField("you@school.edu", text: $email)
				.keyboardType(.emailAddress)
				.textInputAutocapitalization(.never)
				.textContentType(.emailAddress)
				.autocorrectionDisabled()
				.padding()
				.background(Color.gray.opacity(0.12))
				.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
				.padding(.horizontal, Constants.UI.largePadding)
				.onChange(of: email) {
					detectedSchool = appState.school(forEmail: email)
					showError = false
				}

			if let school = detectedSchool {
				Label(school.name, systemImage: "checkmark.circle.fill")
					.foregroundStyle(.green)
					.font(.subheadline)
			}

			if showError {
				Text("Please enter a valid .edu email address")
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
