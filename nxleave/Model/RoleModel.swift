//
//  RoleModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import Foundation

struct RoleModel: Codable, Selectable {
    var id: String
    var name: String
    let enable: Bool
    let accessLevel: AccessLevel
    
    func changeId(id: String) -> RoleModel {
        RoleModel(
            id: id,
            name: self.name,
            enable: self.enable,
            accessLevel: self.accessLevel
        )
    }
    
    func changeEnable(enable: Bool) -> RoleModel {
        RoleModel(
            id: self.id,
            name: self.name,
            enable: enable,
            accessLevel: self.accessLevel
        )
    }
}

let allRole = RoleModel(id: "", name: "All", enable: true, accessLevel: AccessLevel.all)

enum AccessLevel: String, Codable, CaseIterable {
    case all = "1"
    case approve = "2"
    case none = "3"
    
    var name: String {
        switch self {
        case .all: return "All"
        case .approve: return "Approve"
        case .none: return "None"
        }
    }
}

struct SelectableAccessLevel: Selectable {
    let accessLevel: AccessLevel
    var id: String
    var name: String
    
    init(accessLevel: AccessLevel) {
        self.accessLevel = accessLevel
        self.id = accessLevel.rawValue
        self.name = accessLevel.name
    }
}

let selectableAccessLevels = [
    SelectableAccessLevel(accessLevel: AccessLevel.all),
    SelectableAccessLevel(accessLevel: AccessLevel.approve),
    SelectableAccessLevel(accessLevel: AccessLevel.none),
]
    
