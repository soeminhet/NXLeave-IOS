//
//  ProfileViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 30/01/2024.
//
import Combine
import Foundation

@MainActor class ProfileViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let realtimeService = RealtimeService()
    private let firestoreService = FirestoreService()
    
    @Published var staff: StaffModel? = nil
    @Published var staffRole: RoleModel? = nil
    
    func fetchCurrentStaff(uid: String) {
        if uid.isEmpty { return }
        realtimeService.currentStaff(uid: uid)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] staff in
                self?.staff = staff
                Task {
                    await self?.fetchStaffRole(id: staff.roleId)
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchStaffRole(id: String) async {
        do {
            self.staffRole = try await firestoreService.getRoleBy(id: id)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
