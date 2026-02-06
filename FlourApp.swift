//
//  FlourApp.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

@main
struct FlourApp: App {
	@State private var appState = AppState()
	@State private var locationService = LocationService()

	var body: some Scene {
		WindowGroup {
			ViewsRootView()
				.environment(appState)
				.environment(locationService)
		}
	}
}
