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
	var isLoading = false
	var errorMessage: String?

	var firebaseUser: FirebaseAuth.User? {
		Auth.auth().currentUser
	}

	var isAuthenticated: Bool { firebaseUser != nil }

	func signUp(email: String, password: String, displayName: String) async throws {
		isLoading = true
		errorMessage = nil
		defer { isLoading = false }

		do {
			let result = try await Auth.auth().createUser(withEmail: email, password: password)
			let changeRequest = result.user.createProfileChangeRequest()
			changeRequest.displayName = displayName
			try await changeRequest.commitChanges()
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
			_ = try await Auth.auth().signIn(withEmail: email, password: password)
		} catch {
			errorMessage = error.localizedDescription
			throw error
		}
	}

	func signOut() {
		try? Auth.auth().signOut()
	}
}
