//
//  LeaveTypeModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import Foundation

struct LeaveTypeModel: Selectable, Codable {
    var id: String
    var name: String
    let color: UInt64
    var enable: Bool
    
    func changeId(id: String) -> LeaveTypeModel {
        LeaveTypeModel(
            id: id,
            name: self.name,
            color: self.color,
            enable: self.enable
        )
    }
    
    func changeEnable(enable: Bool) -> LeaveTypeModel {
        LeaveTypeModel(
            id: self.id,
            name: self.name,
            color: self.color,
            enable: enable
        )
    }
}

let allLeaveType = LeaveTypeModel(id: "", name: "All", color: 12345678, enable: true)
