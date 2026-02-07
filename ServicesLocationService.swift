//
//  LocationService.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation
import CoreLocation
import Observation

@Observable
class LocationService: NSObject, CLLocationManagerDelegate {
	private let manager = CLLocationManager()

	var userLocation: CLLocationCoordinate2D?
	var authorizationStatus: CLAuthorizationStatus = .notDetermined

	// Fallback to University of Utah campus
	var currentLocation: CLLocationCoordinate2D {
		userLocation ?? CLLocationCoordinate2D(
			latitude: MockData.campusCenter.latitude,
			longitude: MockData.campusCenter.longitude
		)
	}

	var currentLocationCoordinate: LocationCoordinate {
		LocationCoordinate(coordinate: currentLocation)
	}

	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
	}

	func requestPermission() {
		manager.requestWhenInUseAuthorization()
	}

	func startUpdating() {
		manager.startUpdatingLocation()
	}

	func stopUpdating() {
		manager.stopUpdatingLocation()
	}

	// MARK: - CLLocationManagerDelegate

	nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		Task { @MainActor in
			self.userLocation = locations.last?.coordinate
		}
	}

	nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		Task { @MainActor in
			self.authorizationStatus = manager.authorizationStatus
			if manager.authorizationStatus == .authorizedWhenInUse ||
				manager.authorizationStatus == .authorizedAlways {
				manager.startUpdatingLocation()
			}
		}
	}
}
