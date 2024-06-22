//
//  AssignedTeamViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//
import SwiftUI
import Foundation

@MainActor class AssignedTeamViewModel: ObservableObject {
    
    private let firestoreService = FirestoreService()
    
    @AppStorage("uid") var uid: String = ""
    @Published var loading: Bool = false
    @Published var teams: [String] = []
    
    func fetchStaffProjects() async {
        loading = true
        do {
            let staff = try await firestoreService.getStaffBy(id: uid)
            teams = try await firestoreService.getProjectsBy(ids: staff.currentProjectIds).map{ $0.name }
        } catch(let error) {
            print(error.localizedDescription)
        }
        loading = false
    }
}
