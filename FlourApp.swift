//
//  FlourApp.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI
import FirebaseCore

@main
struct FlourApp: App {
	@State private var appState = AppState()
	@State private var locationService = LocationService()

	init() {
		FirebaseApp.configure()
	}

	var body: some Scene {
		WindowGroup {
			ViewsRootView()
				.environment(appState)
				.environment(locationService)
		}
	}
}
