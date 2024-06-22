//
//  ApproveViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 28/01/2024.
//

import Combine
import Foundation

@MainActor class ApproveViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let realtimeService = RealtimeService()
    private let firestoreService = FirestoreService()
    
    @Published var loading: Bool = false
    @Published private var staff: StaffModel? = nil
    @Published private var requests: [LeaveRequestModel] = []
    @Published private var staves: [StaffModel] = []
    @Published private var leaveTypes: [LeaveTypeModel] = []
    @Published private var roles: [RoleModel] = []
    @Published private var leaveRequests: [LeaveRequestUiModel] = []
    @Published var filteredLeaveRequests: [LeaveRequestUiModel] = []
    @Published var currentTab: LeaveStatus = LeaveStatus.All
    
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
        
        $currentTab
            .combineLatest($leaveRequests)
            .map { tab, requests -> [LeaveRequestUiModel] in
                if tab == .All { return requests }
                return requests.filter{ $0.leaveStatus == tab }
            }
            .sink { [weak self] requests in
                self?.filteredLeaveRequests = requests
            }
            .store(in: &cancellables)
    }
    
    func fetchLeaveTypes() {
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
    
    func fetchRoles() {
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
                var staffIds = staves.map { $0.id }
                
                let adminRoles = self?.roles.filter{ $0.accessLevel == AccessLevel.all }
                let isAdmin = adminRoles?.first(where: {  $0.id == self?.staff?.roleId }) != nil
                if !isAdmin {
                    staffIds = staves
                        .filter { staff in adminRoles?.first { admin in admin.id == staff.roleId } == nil }
                        .map { $0.id }
                }
                
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
    
    func getLeaveDetail(by id: String) async -> LeaveRequestDetailUiModel {
        loading = true
        let request = requests.first{ $0.id == id }!
        let leaveType = leaveTypes.first{ $0.id == request.leaveTypeId }
        let role = roles.first{ $0.id == staff?.roleId }
        let approver = request.approverId.isEmpty ? nil : try? await firestoreService.getStaffBy(id: request.approverId).name
        
        var projects = ""
        if let projectIds = try? await firestoreService.getStaffBy(id: request.staffId).currentProjectIds {
            if !projectIds.isEmpty {
                let projectsName = (try? await firestoreService.getProjectsBy(ids: projectIds).map{ $0.name }) ?? []
                projects = projectsName.joined(separator: ", ")
            }
        }
        
        loading = false
        
        return LeaveRequestDetailUiModel(
            id: id,
            name: staff?.name ?? "",
            roleName: role?.name ?? "",
            startDate: request.startDate.format(with: .dayMonthYear),
            endDate: request.endDate?.format(with: .dayMonthYear) ?? "",
            applyDate: request.leaveApplyDate.format(with: .dayMonthYear),
            approveDate: request.leaveApprovedDate?.format(with: .dayMonthYear) ?? "",
            rejectedDate: request.leaveRejectedDate?.format(with: .dayMonthYear) ?? "",
            approver: approver ?? "",
            currentProjects: projects,
            leaveTypeName: leaveType?.name ?? "",
            leaveStatus: request.leaveStatus
        )
    }
    
    func leaveStatusUpdate(id: String, status: LeaveStatus) {
        guard let request = requests.first(where: { $0.id == id }) else { return }
        let updatedRequest = request.changeLeaveStatus(
            approverId: staff!.id,
            status: status
        )
        do {
            try firestoreService.updateLeaveRequest(with: updatedRequest)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
