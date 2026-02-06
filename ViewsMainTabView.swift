//
//  MainTabView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI

struct ViewsMainTabView: View {
	@Environment(AppState.self) private var appState
	@State private var selectedTab = 0
	@State private var showCreateRequest = false

	var body: some View {
		TabView(selection: $selectedTab) {
			Tab("Feed", systemImage: "list.bullet", value: 0) {
				NavigationStack {
					ViewsFeedView()
				}
			}

			Tab("Map", systemImage: "map", value: 1) {
				NavigationStack {
					ViewsMapView()
				}
			}

			Tab("Activity", systemImage: "bell", value: 2) {
				NavigationStack {
					ViewsActivityView()
				}
			}

			Tab("Profile", systemImage: "person", value: 3) {
				NavigationStack {
					ViewsProfileView()
				}
			}
		}
		.overlay(alignment: .bottom) {
			Button {
				showCreateRequest = true
			} label: {
				Image(systemName: "plus.circle.fill")
					.font(.system(size: 56))
					.foregroundStyle(.green)
					.background(Circle().fill(.white).padding(4))
					.shadow(radius: 4)
			}
			.offset(y: -4)
		}
		.sheet(isPresented: $showCreateRequest) {
			NavigationStack {
				ViewsCreateRequestView()
			}
		}
	}
}
