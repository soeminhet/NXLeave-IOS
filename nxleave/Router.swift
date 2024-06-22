//
//  Router.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 23/01/2024.
//

import Foundation
import SwiftUI

@MainActor public final class Router: ObservableObject {
    @Published var navPath = NavigationPath()
    public init() {}

    public func navigate(to destination: any Hashable) {
        navPath.append(destination)
    }

    public func navigateBack() {
        navPath.removeLast()
    }

    public func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
