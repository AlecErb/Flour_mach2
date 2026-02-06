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
	let detectedSchool: School?

	@State private var displayName = ""
	@State private var phone = ""
	@State private var showError = false

	private var isValid: Bool {
		displayName.count >= Constants.Validation.minDisplayNameLength &&
		displayName.count <= Constants.Validation.maxDisplayNameLength &&
		phone.count >= 7
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
			}
			.padding(.horizontal, Constants.UI.largePadding)

			if let school = detectedSchool {
				Label(school.name, systemImage: "building.columns")
					.foregroundStyle(.secondary)
					.font(.subheadline)
			}

			if showError {
				Text("Please fill in all fields correctly")
					.foregroundStyle(.red)
					.font(.caption)
			}

			Spacer()

			Button {
				if isValid {
					let schoolId = detectedSchool?.id ?? "unknown"
					appState.createUser(
						displayName: displayName,
						email: email,
						phone: phone,
						schoolId: schoolId
					)
				} else {
					showError = true
				}
			} label: {
				Text("Create Account")
					.font(.headline)
					.frame(maxWidth: .infinity)
					.frame(height: Constants.UI.buttonHeight)
			}
			.buttonStyle(.borderedProminent)
			.tint(.green)
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
