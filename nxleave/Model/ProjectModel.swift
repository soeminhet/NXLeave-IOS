//
//  ProjectModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 28/01/2024.
//

import Foundation

struct ProjectModel: MultiSelectable, Codable {
    var id: String
    var name: String
    let enable: Bool
    
    func changeId(id: String) -> ProjectModel {
        ProjectModel(id: id, name: self.name, enable: self.enable)
    }
    
    func changeEnable(enable: Bool) -> ProjectModel {
        ProjectModel(id: self.id, name: self.name, enable: enable)
    }
}

let allProject = ProjectModel(id: "", name: "All", enable: true)
