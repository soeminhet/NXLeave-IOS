//
//  LeaveBalanceModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import Foundation

struct LeaveBalanceModel: Codable {
    let id: String
    let roleId: String
    let leaveTypeId: String
    let balance: Int
    
    func changeId(id: String) -> LeaveBalanceModel {
        LeaveBalanceModel(
            id: id,
            roleId: self.roleId,
            leaveTypeId: self.leaveTypeId,
            balance: self.balance
        )
    }
}

struct LeaveBalanceUiModel: Identifiable {
    let id: String
    let color: UInt64
    let name: String
    let took: Double
    let total: Double
    let enable: Bool
}

struct LeaveBalanceManageUiModel: Identifiable {
    let id: String
    let roleId: String
    let leaveTypeId: String
    let leaveTypeName: String
    var balance: Int
}

