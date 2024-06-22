//
//  DashboardViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class DashboardViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let firestoreService = FirestoreService()
    private let realtimeService = RealtimeService()
    
    @Published var events: [EventModel] = []
    @Published var staff: StaffModel? = nil
    @Published private var requests: [LeaveRequestModel] = []
    @Published private var staves: [StaffModel] = []
    @Published private var leaveTypes: [LeaveTypeModel] = []
    @Published private var roles: [RoleModel] = []
    @Published var leaveRequests: [LeaveRequestUiModel] = []
    
    init() {
        $requests
            .combineLatest($staves, $leaveTypes, $roles)
            .map { requests, staves, leaveTypes, roles -> [LeaveRequestUiModel] in
                requests.map { request in
                    let staff = staves.first { $0.id == request.staffId }
                    let role = roles.first { $0.id == staff?.roleId }
                    let leaveType = leaveTypes.first { $0.id == request.leaveTypeId }
                    let dateRange = getDateRange(startDate: request.startDate, endDate: request.endDate, period: request.period)
                    return LeaveRequestUiModel(
                        id: request.id,
                        name: staff?.name ?? "",
                        roleName: role?.name ?? "",
                        dateRange: dateRange,
                        leaveTypeName: leaveType?.name ?? "",
                        leaveStatus: request.leaveStatus,
                        duaration: Double(request.duration)?.toDays() ?? ""
                    )
                }
            }
            .sink { [weak self] requests in
                self?.leaveRequests = requests
            }
            .store(in: &cancellables)
    }
    
    func loadData(uid: String) {
        fetchUpcomingEvents()
        fetchCurrentStaff(uid: uid)
        fetchLeaveTypes()
        fetchRoles()
    }
    
    private func fetchUpcomingEvents() {
        realtimeService.allUpcomingEvents(with: 10)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] events in
                self?.events = events
            }
            .store(in: &cancellables)
    }
    
    private func fetchLeaveTypes() {
        realtimeService.allLeaveTypes()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] leaveTypes in
                self?.leaveTypes = leaveTypes
            }
            .store(in: &cancellables)
    }
    
    private func fetchRoles() {
        realtimeService.allRoles()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] roles in
                self?.roles = roles
            }
            .store(in: &cancellables)
    }
    
    private func fetchCurrentStaff(uid: String) {
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
                self?.fetchRelatedStaves(projectIds: staff.currentProjectIds)
            }
            .store(in: &cancellables)
    }
    
    private func fetchRelatedStaves(projectIds: [String]) {
        if projectIds.isEmpty { return }
        realtimeService.relatedStaves(projectIds: projectIds)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] staves in
                let staffIds = staves.map { $0.id }
                self?.staves = staves
                self?.fetchRelatedLeaveRequests(staffIds: staffIds)
            }
            .store(in: &cancellables)
    }
    
    private func fetchRelatedLeaveRequests(staffIds: [String]) {
        if staffIds.isEmpty { return }
        realtimeService.relatedLeaveRequest(staffIds: staffIds)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] requests in
                self?.requests = requests
            }
            .store(in: &cancellables)
    }
}
