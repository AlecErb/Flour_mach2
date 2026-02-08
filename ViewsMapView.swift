//
//  MapView.swift
//  Flour
//
//  Created on 2026-02-06.
//

import SwiftUI
import MapKit

struct ViewsMapView: View {
	@Environment(AppState.self) private var appState
	@Environment(LocationService.self) private var locationService

	@Binding var requestToZoomTo: Request?

	@State private var selectedRequest: Request?
	@State private var cameraPosition: MapCameraPosition = .automatic

	var body: some View {
		Map(position: $cameraPosition) {
			// User location
			UserAnnotation()

			// Request pins
			ForEach(appState.activeRequests) { request in
				Annotation(
					request.itemDescription,
					coordinate: request.location.clLocationCoordinate
				) {
					Button {
						selectedRequest = request
					} label: {
						VStack(spacing: 2) {
							Image(systemName: urgencyIcon(request.urgency))
								.font(.title3)
								.foregroundStyle(.white)
								.padding(8)
								.background(urgencyColor(request.urgency))
								.clipShape(Circle())

							Text(request.formattedPrice)
								.font(.caption2)
								.fontWeight(.semibold)
								.padding(.horizontal, 4)
								.padding(.vertical, 2)
								.background(.white)
								.clipShape(Capsule())
								.shadow(radius: 1)
						}
					}
				}
			}
		}
		.mapControls {
			MapUserLocationButton()
			MapCompass()
		}
		.navigationTitle("Nearby Requests")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear {
			locationService.requestPermission()
		}
		.onChange(of: requestToZoomTo) { oldValue, newValue in
			if let request = newValue {
				// Zoom to the new request with animation
				withAnimation(.easeInOut(duration: 0.5)) {
					cameraPosition = .region(
						MKCoordinateRegion(
							center: request.location.clLocationCoordinate,
							span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
						)
					)
				}
				// Clear the binding so it can be triggered again
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
					requestToZoomTo = nil
				}
			}
		}
		.sheet(item: $selectedRequest) { request in
			NavigationStack {
				ViewsRequestDetailView(request: request)
			}
			.presentationDetents([.medium, .large])
		}
	}

	private func urgencyIcon(_ urgency: Urgency) -> String {
		switch urgency {
		case .asap: return "bolt.fill"
		case .thirtyMinutes: return "clock.fill"
		case .oneHour: return "clock"
		case .flexible: return "leaf.fill"
		}
	}

	private func urgencyColor(_ urgency: Urgency) -> Color {
		switch urgency {
		case .asap: return .red
		case .thirtyMinutes: return .orange
		case .oneHour: return .blue
		case .flexible: return .green
		}
	}
}
