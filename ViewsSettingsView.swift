//
//  SettingsView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsSettingsView: View {
	@State private var pushNotifications = true
	@State private var chatNotifications = true
	@State private var offerNotifications = true

	var body: some View {
		List {
			Section("Notifications") {
				Toggle("Push Notifications", isOn: $pushNotifications)
				Toggle("New Chat Messages", isOn: $chatNotifications)
				Toggle("Offer Updates", isOn: $offerNotifications)
			}

			Section("Payment") {
				HStack {
					Label("Payment Method", systemImage: "creditcard")
					Spacer()
					Text("Not set up")
						.foregroundStyle(.secondary)
				}

				HStack {
					Label("Platform Fee", systemImage: "percent")
					Spacer()
					Text("10% (max $2)")
						.foregroundStyle(.secondary)
				}
			}

			Section("About") {
				HStack {
					Text("Version")
					Spacer()
					Text("\(Constants.App.version) (\(Constants.App.buildNumber))")
						.foregroundStyle(.secondary)
				}

				Link(destination: URL(string: Constants.URLs.termsOfService)!) {
					Label("Terms of Service", systemImage: "doc.text")
				}

				Link(destination: URL(string: Constants.URLs.privacyPolicy)!) {
					Label("Privacy Policy", systemImage: "lock.shield")
				}

				Link(destination: URL(string: Constants.URLs.support)!) {
					Label("Support", systemImage: "questionmark.circle")
				}
			}
		}
		.navigationTitle("Settings")
		.navigationBarTitleDisplayMode(.inline)
	}
}
