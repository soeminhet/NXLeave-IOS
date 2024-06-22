//
//  AppViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 06/02/2024.
//

import Foundation
import SwiftUI

@MainActor class OnboardViewModel: ObservableObject {
    
    @AppStorage("uid") var uid = ""
    
    private let firestoreService = FirestoreService()
    private let authService = AuthService()
    
    @Published var isInitialized: Bool = false
    @Published var loading: Bool = false
    @Published var startedSuccess: Bool = false
    
    func fetchIsInitialized() async {
        do {
            isInitialized = try await firestoreService.isInitialized()
        } catch(let error){
            print(error.localizedDescription)
        }
    }
    
    func getStarted() {
        loading = true
        Task {
            do {
                let adminRole = RoleModel(id: "", name: "Admin", enable: true, accessLevel: AccessLevel.all)
                try firestoreService.addRoleBy(model: adminRole)
                let role = try await firestoreService.getAllRoles().first!
                let auth = try await authService.signup(email: "admin@nxleave.co", password: "Nxleave@2023")
                let staff = StaffModel(
                    id: auth.id,
                    roleId: role.id,
                    name: "Admin",
                    email: auth.email,
                    phoneNumber: "",
                    currentProjectIds: [],
                    photo: "",
                    enable: true
                )
                try firestoreService.addStaffBy(model: staff)
                uid = auth.id
                self.startedSuccess = true
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
        loading = false
    }
}
