//
//  RolesViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//
import Combine
import Foundation

@MainActor class RoleViewModel: ObservableObject {
    
    private let firestoreService = FirestoreService()
    
    @Published var loading: Bool = false
    @Published var roles: [RoleModel] = []
    @Published var exist: Bool = false
    
    func fetchRoles() async {
        loading = true
        do {
            roles = try await firestoreService.getAllRoles().sorted(by: { $0.name < $1.name})
        } catch(let error) {
            print(error.localizedDescription)
        }
        loading = false
    }
    
    func manageRole(model: RoleModel) {
        loading = true
        if model.id.isEmpty {
            if(checkExist(model: model, models: roles)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            addRole(model: model)
        } else {
            if(nameChanged(model: model, models: roles) && checkExist(model: model, models: roles)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            updateRole(model: model)
        }
        Task { await fetchRoles() }
    }
    
    private func updateRole(model: RoleModel) {
        do {
            try firestoreService.updateRoleBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func addRole(model: RoleModel) {
        do {
            try firestoreService.addRoleBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
