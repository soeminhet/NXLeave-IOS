//
//  EnvironmentKey.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 06/02/2024.
//

import SwiftUI

struct AccessLevelKey: EnvironmentKey {
    static var defaultValue: AccessLevel = .none
}

extension EnvironmentValues {
    var accessLevel: AccessLevel {
        get { self[AccessLevelKey.self] }
        set { self[AccessLevelKey.self] = newValue }
    }
}
