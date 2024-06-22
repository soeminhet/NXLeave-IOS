//
//  Period.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import Foundation

struct PeriodModel: Selectable {
    var id: String
    var name: String
}

let periods = [
    PeriodModel(id: "AM", name: "AM"),
    PeriodModel(id: "PM", name: "PM")
]


