//
//  RootView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsRootView: View {
	@Environment(AppState.self) private var appState

	@State private var onboardingStep = 0
	@State private var email = ""

	var body: some View {
		Group {
			if appState.isLoggedIn {
				ViewsMainTabView()
			} else {
				onboardingFlow
			}
		}
	}

	@ViewBuilder
	private var onboardingFlow: some View {
		switch onboardingStep {
		case -1:
			// Demo login requested
			Color.clear.onAppear {
				appState.loginAsDemo()
			}
		case 0:
			ViewsOnboardingWelcomeView(onboardingStep: $onboardingStep)
		case 1:
			ViewsOnboardingEmailView(
				onboardingStep: $onboardingStep,
				email: $email
			)
		case 2:
			ViewsOnboardingProfileSetupView(
				onboardingStep: $onboardingStep,
				email: email
			)
		case 3:
			ViewsOnboardingSignInView(onboardingStep: $onboardingStep)
		default:
			ViewsOnboardingWelcomeView(onboardingStep: $onboardingStep)
		}
	}
}
