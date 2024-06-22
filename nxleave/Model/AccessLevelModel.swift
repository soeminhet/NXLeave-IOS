//
//  AccessLevelModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 27/01/2024.
//

import Foundation

struct AccessLevelModel: Selectable {
    var id: String
    var name: String
}

let accessLevels = [
    AccessLevelModel(id: "1", name: "All"),
    AccessLevelModel(id: "2", name: "Approve"),
    AccessLevelModel(id: "3", name: "None")
]
