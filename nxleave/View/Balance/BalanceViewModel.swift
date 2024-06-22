//
//  BalanceViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//
import Combine
import Foundation
import SwiftUI

@MainActor class BalanceViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let realtimeService = RealtimeService()
    private let firestoreService = FirestoreService()
    
    @Published var loading: Bool = false
    @Published var isAdmin: Bool = false
    @Published var leftDays: Double = 0.0
    @Published var staff: StaffModel? = nil
    @Published var leaveTypes: [LeaveTypeModel] = []
    @Published var progresses: [CircleProgressModel] = []
    @Published var leaveRequests: [LeaveRequestUiModel] = []
    @Published var myLeaveBalances: [LeaveBalanceUiModel] = []
    @Published private var requests: [LeaveRequestModel] = []
    @Published private var leaveBalances: [LeaveBalanceModel] = []
    @Published private var roles: [RoleModel] = []
    
    init() {
        $requests
            .combineLatest($staff, $leaveTypes, $leaveBalances)
            .map { requests, staff, leaveTypes, leaveBalances -> ([CircleProgressModel], [LeaveBalanceUiModel], Double)  in
                
                let filteredLeaveTypes = leaveTypes.filter{ $0.enable }
                let filteredRequests = requests.filter{ request in (filteredLeaveTypes.first{ $0.id == request.leaveTypeId } != nil) && request.leaveStatus != LeaveStatus.Rejected }

                let totalDays = leaveBalances
                    .filter { $0.roleId == staff?.roleId }
                    .filter { balance in filteredLeaveTypes.first{ $0.id == balance.leaveTypeId } != nil }
                    .reduce(0) { $0 + $1.balance }
                let tookDays = filteredRequests.compactMap { Double($0.duration) }.reduce(0, +)
                let leftDays = Double(totalDays) - tookDays
                
                let leaveTypeDuartion = Dictionary(grouping: filteredRequests) { $0.leaveTypeId }
                    .mapValues { requests in
                        requests
                            .filter{ $0.leaveStatus != LeaveStatus.Rejected }
                            .compactMap { Double($0.duration) }
                            .reduce(0, +)
                    }
                
                let myLeaveBalances = leaveBalances.compactMap { balance -> LeaveBalanceUiModel? in
                    guard let leaveType = filteredLeaveTypes.first(where: { $0.id == balance.leaveTypeId }) else { return nil }
                    return LeaveBalanceUiModel(
                        id: balance.id,
                        color: leaveType.color,
                        name: leaveType.name,
                        took: leaveTypeDuartion[balance.leaveTypeId] ?? 0,
                        total: Double(balance.balance),
                        enable: leaveType.enable
                    )
                }
                
                let progresses = leaveTypeDuartion
                    .mapValues { totalDuartion in
                        return ( totalDuartion / Double(totalDays)) * 100
                    }
                    .compactMap{ (key: String, value: Double) -> CircleProgressModel? in
                        guard let color = leaveTypes.first(where: { $0.id == key })?.color else { return nil }
                        return CircleProgressModel(color: color, percent: value)
                    }
                
                let newProgresses = progresses
                    .enumerated()
                    .map { index, model in
                        let showProgress = progresses[index...].reduce(0) { $0 + $1.percent } / 100
                        return CircleProgressModel(color: model.color, percent: showProgress * 360)
                    }
                
                return (newProgresses, myLeaveBalances, leftDays)
            }
            .sink { [weak self] (progresses, myLeaveBalances, leftDays) in
                guard let self = self else { return }
                self.progresses = progresses
                self.leftDays = leftDays
                self.myLeaveBalances = myLeaveBalances
            }
            .store(in: &cancellables)
        
        
        $requests
            .combineLatest($leaveTypes)
            .map { requests, leaveTypes -> [LeaveRequestUiModel] in
                requests.map { request in
                    let leaveType = leaveTypes.first { $0.id == request.leaveTypeId }
                    let dateRange = getDateRange(startDate: request.startDate, endDate: request.endDate, period: request.period)
                    return LeaveRequestUiModel(
                        id: request.id,
                        name: request.duration.toDays(),
                        roleName: "",
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
        
        
        $staff
            .combineLatest($roles)
            .map { staff, roles -> Bool in
                roles.first(where: { $0.id == staff?.roleId })?.accessLevel == AccessLevel.all
            }
            .sink { [weak self] isAdmin in
                self?.isAdmin = isAdmin
            }
            .store(in: &cancellables)
    }
    
    func checkLeaveLeft(leaveTypeId: String, duration: String) -> (Bool, String) {
        let balance = Double(leaveBalances.first(where: { $0.leaveTypeId == leaveTypeId && $0.roleId == staff?.roleId })?.balance ?? 0)
        let durationDouble = Double(duration) ?? 0

        if balance >= durationDouble {
            return (true, "")
        }
        
        let leaveTypeName = leaveTypes.first(where: { $0.id == leaveTypeId })?.name ?? ""
        let tookLeaves = requests.filter { $0.leaveTypeId == leaveTypeId }
            .compactMap { Double($0.duration) }
            .reduce(0, +)
        let leftLeaves = balance - tookLeaves
        return(false, "You have only \(leftLeaves.toDays()) left for \(leaveTypeName)")
    }
    
    func submitRequest(_ request: LeaveRequestModel) {
        loading = true
        Task {
            do {
                let updatedRequest = isAdmin ? request.changeLeaveStatus(approverId: staff!.id, status: LeaveStatus.Approved) : request
                try firestoreService.submitLeaveRequest(with: updatedRequest)
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
        loading = false
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
                guard let self = self else { return }
                self.staff = staff
                self.fetchLeaveBalances(roleId: staff.roleId)
                self.fetchLeaveRequests(staffId: staff.id)
            }
            .store(in: &cancellables)
    }
    
    private func fetchLeaveRequests(staffId: String) {
        if staffId.isEmpty { return }
        realtimeService.allLeaveRequest(by: staffId)
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
    
    private func fetchLeaveBalances(roleId: String) {
        realtimeService.leaveBalance(by: roleId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] balances in
                self?.leaveBalances = balances
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
    
    func deleteLeaveRequest(with id: String) {
        loading = true
        Task {
            do {
                try await firestoreService.deleteLeaveRequest(with: id)
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
        loading = false
    }
}

