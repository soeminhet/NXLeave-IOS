//
//  nxleaveApp.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 22/01/2024.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase Configure")
        return true
    }
}

@main
struct NxleaveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                LaunchView()
                    .navigationDestination(for: String.self) { destination in
                        if destination == "Onboard" {
                            OnboardView()
                        } else if destination == "Login" {
                            LoginView()
                        } else if destination == "BottomTab" {
                            BottomTabView()
                        } else if destination == "UpcomingEvents" {
                            UpcomingEventsView()
                        } else if destination == "LeaveTypes" {
                            LeaveTypesView()
                        } else if destination == "Roles" {
                            RolesView()
                        } else if destination == "Projects" {
                            ProjectsView()
                        } else if destination == "Staves" {
                            StavesView()
                        } else if destination == "Events" {
                            EventsView()
                        } else if destination == "AssignedTeam" {
                            AssignedTeamView()
                        } else if destination == "LeaveBalances" {
                            LeaveBalancesView()
                        } else if destination == "EditProfile" {
                            EditProfileView()
                        } else if destination == "Report" {
                            ReportView()
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
