//
//  AuthDataService.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//
import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift


class AuthService {
    func login(email: String, password: String) async throws -> AuthUserModel {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = result.user
        signout()
        return AuthUserModel(
            id: user.uid,
            email: user.email ?? email
        )
    }
    
    func signup(email: String, password: String) async throws -> AuthUserModel {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = result.user
        signout()
        return AuthUserModel(id: user.uid, email: user.email ?? email)
    }
    
    private func signout() {
        do {
            try Auth.auth().signOut()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
