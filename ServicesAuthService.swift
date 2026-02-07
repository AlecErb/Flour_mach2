//
//  AuthService.swift
//  Flour
//
//  Created on 2026-02-06.
//

import Foundation
import FirebaseAuth
import Observation

@Observable
class AuthService {
	var firebaseUser: FirebaseAuth.User?
	var isAuthenticated: Bool { firebaseUser != nil }
	var isLoading = false
	var errorMessage: String?

	init() {
		// Restore session from previous launch
		firebaseUser = Auth.auth().currentUser
	}

	func signUp(email: String, password: String, displayName: String) async throws {
		isLoading = true
		errorMessage = nil
		defer { isLoading = false }

		do {
			let result = try await Auth.auth().createUser(withEmail: email, password: password)
			let changeRequest = result.user.createProfileChangeRequest()
			changeRequest.displayName = displayName
			try await changeRequest.commitChanges()
			firebaseUser = result.user
		} catch {
			errorMessage = error.localizedDescription
			throw error
		}
	}

	func signIn(email: String, password: String) async throws {
		isLoading = true
		errorMessage = nil
		defer { isLoading = false }

		do {
			let result = try await Auth.auth().signIn(withEmail: email, password: password)
			firebaseUser = result.user
		} catch {
			errorMessage = error.localizedDescription
			throw error
		}
	}

	func signOut() {
		try? Auth.auth().signOut()
		firebaseUser = nil
	}
}
