//
//  StavesViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//
import Combine
import Foundation

@MainActor class StavesViewModel: ObservableObject {
    
    private let authService = AuthService()
    private let firestoreService = FirestoreService()
    @Published var loading: Bool = false
    @Published var staves: [StaffUiModel] = []
    @Published var originStaves: [StaffModel] = []
    @Published var roles: [RoleModel] = []
    @Published var projects: [ProjectModel] = []
    @Published var exist: Bool = false
    
    func fetchStaves() async {
        loading = true
        do {
            originStaves = try await firestoreService.getAllStaves()
            roles = try await firestoreService.getAllRoles()
            self.staves = originStaves.compactMap { staff -> StaffUiModel? in
                guard let role = roles.first(where: { $0.id == staff.roleId }) else { return nil }
                return StaffUiModel(
                    id: staff.id,
                    name: staff.name,
                    photo: staff.photo,
                    roleName: role.name,
                    email: staff.email,
                    enable: staff.enable
                )
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
        loading = false
    }
    
    func fetchProjects() async {
        do {
            projects = try await firestoreService.getAllProjects()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func changeEnable(id: String, enable: Bool) {
        loading = true
        let staff = originStaves.first(where: { $0.id == id })!
        let updatedStaff = staff.changeEnable(enable: enable)
        do {
            try firestoreService.updateStaffBy(model: updatedStaff)
            Task{ await fetchStaves() }
        } catch(let error) {
            loading = false
            print(error.localizedDescription)
        }
    }
    
    func getStaffModelBy(id: String?) -> StaffModel? {
        guard let id = id else { return nil }
        return originStaves.first(where: { $0.id == id })
    }
    
    func manageStaff(model: StaffModel, password: String) {
        loading = true
        if model.id.isEmpty {
            if(checkExist(model: model, models: originStaves)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            addStaff(model: model, password: password)
        } else {
            if(nameChanged(model: model, models: originStaves) && checkExist(model: model, models: originStaves)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            updateStaff(model: model)
        }
        Task { await fetchStaves() }
    }
    
    private func updateStaff(model: StaffModel) {
        do {
            try firestoreService.updateStaffBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func addStaff(model: StaffModel, password: String) {
        Task {
            do {
                let auth = try await authService.signup(email: model.email, password: password)
                try firestoreService.addStaffBy(model: model.changeId(id: auth.id))
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
}
