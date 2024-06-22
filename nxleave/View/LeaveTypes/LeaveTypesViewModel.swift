//
//  LeaveTypesViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 30/01/2024.
//
import Combine
import Foundation

@MainActor class LeaveTypesViewModel: ObservableObject {
    
    private let firestoreService = FirestoreService()
    
    @Published var loading: Bool = false
    @Published var leaveTypes: [LeaveTypeModel] = []
    @Published var exist: Bool = false
    
    func fetchLeaveTypes() async {
        loading = true
        do {
            leaveTypes = try await firestoreService.getAllLeaveTypes().sorted(by: { $0.name < $1.name})
        } catch(let error) {
            print(error.localizedDescription)
        }
        loading = false
    }
    
    func manageLeaveType(model: LeaveTypeModel) {
        loading = true
        if model.id.isEmpty {
            if(checkExist(model: model, models: leaveTypes)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            addLeaveType(model: model)
        } else {
            if(nameChanged(model: model, models: leaveTypes) && checkExist(model: model, models: leaveTypes)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            updateLeaveType(model: model)
        }
        Task { await fetchLeaveTypes() }
    }
    
    private func updateLeaveType(model: LeaveTypeModel) {
        do {
            try firestoreService.updateLeaveTypeBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func addLeaveType(model: LeaveTypeModel) {
        do {
            try firestoreService.addLeaveTypeBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
