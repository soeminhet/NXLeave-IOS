//
//  EventModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import Foundation

struct EventModel: Selectable, Codable {
    var id: String
    var name: String
    let date: Date
    
    func changeId(id: String) -> EventModel {
        EventModel(id: id, name: self.name, date: self.date)
    }
}
