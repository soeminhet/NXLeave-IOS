//
//  LoginViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import Foundation
import SwiftUI

@MainActor class LoginViewModel: ObservableObject {
    
    @AppStorage("uid") var uid: String = ""
    private var authService: AuthService
    
    @Published var success: Bool = false
    @Published var error: String = ""
    @Published var loading: Bool = false
    
    init() {
        self.authService = AuthService()
    }
    
    func login(email: String, password: String) async {
        loading = true
        do {
            let user = try await authService.login(email: email, password: password)
            uid = user.id
            success = true
        } catch(let error) {
            self.error = error.localizedDescription
        }
        loading = false
    }
}
