//
//  FeedView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsFeedView: View {
	@Environment(AppState.self) private var appState
	@Environment(LocationService.self) private var locationService

	@State private var searchText = ""
	@State private var filterUrgency: Urgency?

	private var filteredRequests: [Request] {
		var result = appState.activeRequests

		// Don't show current user's own requests
		if let userId = appState.currentUser?.id {
			result = result.filter { $0.requesterId != userId }
		}

		if let urgency = filterUrgency {
			result = result.filter { $0.urgency == urgency }
		}

		if !searchText.isEmpty {
			result = result.filter {
				$0.itemDescription.localizedCaseInsensitiveContains(searchText)
			}
		}

		return result.sorted { $0.urgency.sortOrder < $1.urgency.sortOrder }
	}

	var body: some View {
		Group {
			if filteredRequests.isEmpty {
				ContentUnavailableView(
					"No requests nearby",
					systemImage: "tray",
					description: Text("Check back soon or try a different filter.")
				)
			} else {
				ScrollView {
					LazyVStack(spacing: 12) {
						ForEach(filteredRequests) { request in
							NavigationLink(value: request) {
								SharedRequestCard(
									request: request,
									userLocation: locationService.currentLocation,
									requesterName: appState.user(withId: request.requesterId)?.displayName
								)
							}
							.buttonStyle(.plain)
						}
					}
					.padding()
				}
			}
		}
		.navigationTitle("Feed")
		.searchable(text: $searchText, prompt: "Search requests...")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Menu {
					Button("All") { filterUrgency = nil }
					ForEach(Urgency.allCases, id: \.self) { urgency in
						Button(urgency.displayName) { filterUrgency = urgency }
					}
				} label: {
					Image(systemName: filterUrgency == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
				}
			}
		}
		.navigationDestination(for: Request.self) { request in
			ViewsRequestDetailView(request: request)
		}
	}
}
