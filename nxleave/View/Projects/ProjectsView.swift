//
//  ProjectsView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//

import SwiftUI

struct ProjectsView: View {
    
    @StateObject private var viewModel = ProjectsViewModel()
    @State private var showManageOption: Bool = false
    @State private var selectedProject: ProjectModel? = nil
    @State private var showManage: Bool = false
    @State private var showDisable: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.projects, id: \.id) { project in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(project.name)
                                .padding()
                                .opacity(project.enable ? 1 : 0.5)
                            
                            Divider()
                        }
                        .background(.black.opacity(0.0001))
                        .onTapGesture {
                            showManageOption.toggle()
                            selectedProject = project
                        }
                    }
                }
            }
            
            Button {
                showManage.toggle()
                selectedProject = nil
            } label: {
                NXAddCircle()
            }
            .padding()
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .animation(.default, value: viewModel.loading)
        .navigationTitle("Projects")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchProjects()
        }
        .confirmationDialog("", isPresented: $showManageOption) {
            Button("Edit"){ showManage.toggle() }
            
            if selectedProject?.enable == true {
                Button("Disable", role: .destructive){
                    showDisable.toggle()
                }
            } else {
                Button("Enable"){
                    let project = selectedProject!.changeEnable(enable: true)
                    viewModel.manageProject(model: project)
                }
            }
            
            Button("CANCEL", role: .cancel){}
        }
        .sheet(isPresented: $showManage) {
            ManageProjectSheet(project: selectedProject) { project in
                viewModel.manageProject(model: project)
            }
        }
        .alert(isPresented: $showDisable) {
            Alert(
                title: Text("Disable"),
                message: Text("Are you sure want to disable \(selectedProject?.name ?? "")?"),
                primaryButton: .default(Text("OK"), action: {
                    let project = selectedProject!.changeEnable(enable: false)
                    viewModel.manageProject(model: project)
                }),
                secondaryButton: .cancel()
            )
        }
        .alert(isPresented: $viewModel.exist) {
            Alert(
                title: Text("Sorry"),
                message: Text("Project name already exist."),
                dismissButton: .cancel()
            )
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProjectsView()
        }
    }
}
