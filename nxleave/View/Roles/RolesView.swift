//
//  RolesView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//

import SwiftUI

struct RolesView: View {
    
    @StateObject private var viewModel = RoleViewModel()
    @State private var showManageOption: Bool = false
    @State private var selectedRole: RoleModel? = nil
    @State private var showManage: Bool = false
    @State private var showDisable: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.roles, id: \.id) { role in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(role.name)
                                .padding()
                                .opacity(role.enable ? 1 : 0.5)
                            
                            Divider()
                        }
                        .background(.black.opacity(0.0001))
                        .onTapGesture {
                            showManageOption.toggle()
                            selectedRole = role
                        }
                    }
                }
            }
            
            Button {
                showManage.toggle()
                selectedRole = nil
            } label: {
                NXAddCircle()
            }
            .padding()
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .animation(.default, value: viewModel.loading)
        .navigationTitle("Roles")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchRoles()
        }
        .confirmationDialog("", isPresented: $showManageOption) {
            Button("Edit"){ showManage.toggle() }
            
            if selectedRole?.enable == true {
                Button("Disable", role: .destructive){
                    showDisable.toggle()
                }
            } else {
                Button("Enable"){
                    let role = selectedRole!.changeEnable(enable: true)
                    viewModel.manageRole(model: role)
                }
            }
            
            Button("CANCEL", role: .cancel){}
        }
        .sheet(isPresented: $showManage) {
            ManageRoleSheet(role: selectedRole) { role in
                viewModel.manageRole(model: role)
            }
        }
        .alert(isPresented: $showDisable) {
            Alert(
                title: Text("Disable"),
                message: Text("Are you sure want to disable \(selectedRole?.name ?? "")?"),
                primaryButton: .default(Text("OK"), action: {
                    let role = selectedRole!.changeEnable(enable: false)
                    viewModel.manageRole(model: role)
                }),
                secondaryButton: .cancel()
            )
        }
        .alert(isPresented: $viewModel.exist) {
            Alert(
                title: Text("Sorry"),
                message: Text("Role name already exist."),
                dismissButton: .cancel()
            )
        }
    }
}

struct RolesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RolesView()
        }
    }
}
