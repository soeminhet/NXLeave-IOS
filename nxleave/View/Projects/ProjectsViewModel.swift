//
//  ProjectsViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//
import Combine
import Foundation

@MainActor class ProjectsViewModel: ObservableObject {
    
    private let firestoreService = FirestoreService()
    
    @Published var loading: Bool = false
    @Published var projects: [ProjectModel] = []
    @Published var exist: Bool = false
    
    func fetchProjects() async {
        loading = true
        do {
            projects = try await firestoreService.getAllProjects().sorted(by: { $0.name < $1.name})
        } catch(let error) {
            print(error.localizedDescription)
        }
        loading = false
    }
    
    func manageProject(model: ProjectModel) {
        loading = true
        if model.id.isEmpty {
            if(checkExist(model: model, models: projects)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            addProject(model: model)
        } else {
            if(nameChanged(model: model, models: projects) && checkExist(model: model, models: projects)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            updateProject(model: model)
        }
        Task { await fetchProjects() }
    }
    
    private func updateProject(model: ProjectModel) {
        do {
            try firestoreService.updateProjectBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func addProject(model: ProjectModel) {
        do {
            try firestoreService.addProjectBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
