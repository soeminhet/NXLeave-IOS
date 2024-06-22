//
//  AppViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 06/02/2024.
//
import Combine
import Foundation

@MainActor class BottomTabViewModel: ObservableObject {

    private let realtimeService = RealtimeService()
    private let firestoreService = FirestoreService()
    
    @Published var roleId: String = ""
    @Published var accessLevel = AccessLevel.none
    @Published var enable: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRole(uid: String) {
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
                self?.enable = staff.enable
                self?.roleId = staff.roleId
            }
            .store(in: &cancellables)
    }
    
    func fetchAccessLeavel(roleId: String) {
        if roleId.isEmpty { return }
        Task {
            do {
                let role = try await firestoreService.getRoleBy(id: roleId)
                print(role.accessLevel.name)
                self.accessLevel = role.accessLevel
            } catch(let error){
                print(error.localizedDescription)
            }
        }
    }
}
