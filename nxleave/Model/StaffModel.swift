//
//  StaffModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import Foundation

struct StaffModel: Selectable, Codable, Equatable {
    var id: String
    let roleId: String
    var name: String
    let email: String
    let phoneNumber: String
    let currentProjectIds: [String]
    let photo: String
    let enable: Bool
    
    func changeId(id: String) -> StaffModel {
        StaffModel(
            id: id,
            roleId: self.roleId,
            name: self.name,
            email: self.email,
            phoneNumber: self.phoneNumber,
            currentProjectIds: self.currentProjectIds,
            photo: self.photo,
            enable: self.enable
        )
    }
    
    func changeEnable(enable: Bool) -> StaffModel {
        StaffModel(
            id: self.id,
            roleId: self.roleId,
            name: self.name,
            email: self.email,
            phoneNumber: self.phoneNumber,
            currentProjectIds: self.currentProjectIds,
            photo: self.photo,
            enable: enable
        )
    }
    
    func changeInfo(name: String, phone: String, photo: String) -> StaffModel {
        StaffModel(
            id: self.id,
            roleId: self.roleId,
            name: name,
            email: self.email,
            phoneNumber: phone,
            currentProjectIds: self.currentProjectIds,
            photo: self.photo,
            enable: self.enable
        )
    }
}

let allStaff = StaffModel(
    id: "",
    roleId: "",
    name: "All",
    email: "",
    phoneNumber: "",
    currentProjectIds: [],
    photo: "",
    enable: true
)

struct StaffUiModel: Identifiable {
    let id: String
    let name: String
    let photo: String
    let roleName: String
    let email: String
    let enable: Bool
}
