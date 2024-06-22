//
//  Selectable.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import Foundation

protocol Selectable: Identifiable {
    var id: String { get set }
    var name: String { get set }
}

protocol MultiSelectable: Selectable, Equatable {}

func checkExist<T: Selectable>(model: T, models: [T]) -> Bool {
    return models.first(where: { $0.name == model.name }) != nil
}

func nameChanged<T: Selectable>(model: T, models: [T]) -> Bool {
    let origin = models.first(where: { $0.id == model.id })!
    return origin.name != model.name
}
