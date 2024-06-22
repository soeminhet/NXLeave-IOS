//
//  LeaveRequestModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import Foundation

struct LeaveRequestModel: Identifiable, Codable {
    var id: String
    let staffId: String
    let leaveTypeId: String
    let approverId: String
    let duration: String
    let startDate: Date
    let endDate: Date?
    let period: String?
    let description: String
    let leaveStatus: LeaveStatus
    let leaveApplyDate: Date
    let leaveApprovedDate: Date?
    let leaveRejectedDate: Date?
    
    func changeId(id: String) -> LeaveRequestModel {
        LeaveRequestModel(
            id: id,
            staffId: self.staffId,
            leaveTypeId: self.leaveTypeId,
            approverId: self.approverId,
            duration: self.duration,
            startDate: self.startDate,
            endDate: self.endDate,
            period: self.period,
            description: self.description,
            leaveStatus: self.leaveStatus,
            leaveApplyDate: self.leaveApplyDate,
            leaveApprovedDate: self.leaveApprovedDate,
            leaveRejectedDate: self.leaveRejectedDate
        )
    }
    
    func changeLeaveStatus(
        approverId: String,
        status: LeaveStatus
    ) -> LeaveRequestModel {
        LeaveRequestModel(
            id: self.id,
            staffId: self.staffId,
            leaveTypeId: self.leaveTypeId,
            approverId: self.approverId,
            duration: self.duration,
            startDate: self.startDate,
            endDate: self.endDate,
            period: self.period,
            description: self.description,
            leaveStatus: status,
            leaveApplyDate: self.leaveApplyDate,
            leaveApprovedDate: status == LeaveStatus.Approved ? Date() : self.leaveApprovedDate,
            leaveRejectedDate: status == LeaveStatus.Rejected ? Date() : self.leaveRejectedDate
        )
    }
}

struct LeaveRequestUiModel: Identifiable {
    let id: String
    let name: String
    let roleName: String
    let dateRange: String
    let leaveTypeName: String
    let leaveStatus: LeaveStatus
    let duaration: String
}

struct LeaveRequestDetailUiModel: Identifiable {
    let id: String
    let name: String
    let roleName: String
    let startDate: String
    let endDate: String
    let applyDate: String
    let approveDate: String
    let rejectedDate: String
    let approver: String
    let currentProjects: String
    let leaveTypeName: String
    let leaveStatus: LeaveStatus
}
