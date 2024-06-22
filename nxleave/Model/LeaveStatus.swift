//
//  LeaveStatus.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 27/01/2024.
//

import SwiftUI
import Foundation

enum LeaveStatus: String, Codable, CaseIterable, Hashable {
    case All = "All"
    case Pending = "Pending"
    case Approved = "Approved"
    case Rejected = "Rejected"

    var color: Color {
        switch self {
        case .Pending:
            return Color.theme.yellow
        case .Approved:
            return Color.theme.green
        case .Rejected:
            return Color.theme.red
        case .All:
            return Color.theme.blackVarient
        }
    }
}
    
