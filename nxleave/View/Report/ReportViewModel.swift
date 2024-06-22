//
//  ReportViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 04/02/2024.
//

import Foundation

@MainActor class ReportViewModel: ObservableObject {
    
    private let realtimeService = RealtimeService()
    private let firestoreService = FirestoreService()
    
    @Published var loading: Bool = false
    @Published var leaveRequests: [LeaveRequestUiModel] = []
    @Published var staves: [StaffModel] = []
    @Published var leaveTypes: [LeaveTypeModel] = []
    @Published var roles: [RoleModel] = []
    @Published var projects: [ProjectModel] = []
    @Published var startDate: Date = Date().startOfMonth()
    @Published var endDate: Date = Date().endOfMonth()
    
    func loadData() async {
        await self.fetchAllStaves()
        await self.fetchAllLeaveTypes()
        await self.fetchAllRoles()
        await filterLeaveRequest(staffModel: allStaff, roleModel: allRole, projectModel: allProject, startDate: startDate, endDate: endDate)
    }
    
    func filterLeaveRequest(staffModel: StaffModel, roleModel: RoleModel, projectModel: ProjectModel, startDate: Date, endDate: Date) async {
        loading = true
        var staffIds: [String] = []
        if staffModel.id.isEmpty && roleModel.id.isEmpty && projectModel.id.isEmpty {
            staffIds = staves.map{ $0.id }
        } else if !staffModel.id.isEmpty {
            staffIds = [staffModel.id]
        } else if !roleModel.id.isEmpty && !projectModel.id.isEmpty {
            staffIds = staves.filter { staff in
                staff.roleId == roleModel.id && staff.currentProjectIds.contains(where: { $0 == projectModel.id })
            }.map{ $0.id }
        } else if !roleModel.id.isEmpty {
            staffIds = staves.filter { staff in
                staff.roleId == roleModel.id
            }.map{ $0.id }
        } else {
            staffIds = staves.filter { staff in
                staff.currentProjectIds.contains(where: { $0 == projectModel.id })
            }.map{ $0.id }
        }
        
        do {
            print(staffIds)
            print(startDate)
            print(endDate)
            let requests = try await firestoreService.getLeaveRequestsBy(staffIds: staffIds, startDate: startDate, endDate: endDate)
            print(requests)
            leaveRequests = requests.map { request in
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
        } catch(let error){
            print(error.localizedDescription)
        }
        loading = false
    }
    
    private func fetchAllStaves() async {
        do {
            staves = try await firestoreService.getAllStaves()
            staves.append(allStaff)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func fetchAllLeaveTypes() async {
        do {
            leaveTypes = try await firestoreService.getAllLeaveTypes()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func fetchAllRoles() async {
        do {
            roles = try await firestoreService.getAllRoles()
            roles.append(allRole)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
