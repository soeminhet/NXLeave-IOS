//
//  LeaveBalancesViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 02/02/2024.
//

import Foundation

struct LeaveBalanceItemUiModel: Identifiable {
    let id: String
    let roleName: String
    let models: [LeaveBalanceManageUiModel]
}

@MainActor class LeaveBalancesViewModel: ObservableObject {
    
    private let firestoreService = FirestoreService()
    @Published var loading: Bool = false
    @Published var leaveBalances: [LeaveBalanceItemUiModel] = []
    
    func fetchLeaveBalances() async {
        loading = true
        do {
            let roles = try await firestoreService.getAllRoles().filter{ $0.enable }
            let leaveTypes = try await firestoreService.getAllLeaveTypes().filter{ $0.enable }
            let balances = try await firestoreService.getAllLeaveBalances()
            
            leaveBalances = roles.map { role -> LeaveBalanceItemUiModel in
                let filteredBalances = balances.filter{ $0.roleId == role.id }
                let balances = leaveTypes.map { type -> LeaveBalanceManageUiModel in
                    if let balance = filteredBalances.first(where: { $0.leaveTypeId == type.id }) {
                        return LeaveBalanceManageUiModel(
                            id: balance.id,
                            roleId: balance.roleId,
                            leaveTypeId: balance.leaveTypeId,
                            leaveTypeName: type.name,
                            balance: balance.balance
                        )
                    } else {
                        return LeaveBalanceManageUiModel(
                            id: "",
                            roleId: role.id,
                            leaveTypeId: type.id,
                            leaveTypeName: type.name,
                            balance: 0
                        )
                    }
                }
                return LeaveBalanceItemUiModel(id: UUID().uuidString, roleName: role.name, models: balances)
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func manageLeaveBalances(item: LeaveBalanceItemUiModel) {
        loading = true
        let originModels = leaveBalances.first(where: { $0.id == item.id })?.models ?? []
        for model in originModels {
            if let matchModel = item.models.first(where: { $0.leaveTypeId == model.leaveTypeId && $0.balance != model.balance }) {
                let model = LeaveBalanceModel(id: matchModel.id, roleId: matchModel.roleId, leaveTypeId: matchModel.leaveTypeId, balance: matchModel.balance)
                if matchModel.id.isEmpty {
                    addLeaveBalance(model: model)
                } else {
                    updateLeaveBalance(model: model)
                }
            }
        }
        Task { await fetchLeaveBalances() }
    }
    
    private func addLeaveBalance(model: LeaveBalanceModel) {
        do {
            try firestoreService.addLeaveBalanceBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func updateLeaveBalance(model: LeaveBalanceModel) {
        do {
            try firestoreService.updateLeaveBalanceBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
