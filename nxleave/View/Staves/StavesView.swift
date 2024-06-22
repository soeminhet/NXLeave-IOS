//
//  StavesView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//

import SwiftUI

struct StavesView: View {
    
    @StateObject private var viewModel = StavesViewModel()
    @State private var showManageOption: Bool = false
    @State private var selectedStaff: StaffUiModel? = nil
    @State private var showManage: Bool = false
    @State private var showDisable: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.staves, id: \.id) { staff in
                        staffItem(staff: staff)
                            .onTapGesture {
                                showManageOption.toggle()
                                selectedStaff = staff
                            }
                    }
                }
            }
            
            Button {
                showManage.toggle()
                selectedStaff = nil
            } label: {
                NXAddCircle()
            }
            .padding()
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .animation(.default, value: viewModel.loading)
        .navigationTitle("Staves")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchStaves()
            await viewModel.fetchProjects()
        }
        .confirmationDialog("", isPresented: $showManageOption) {
            Button("Edit"){ showManage.toggle() }
            
            if selectedStaff?.enable == true {
                Button("Disable", role: .destructive){
                    showDisable.toggle()
                }
            } else {
                Button("Enable"){
                    viewModel.changeEnable(id: selectedStaff!.id, enable: true)
                }
            }
            
            Button("CANCEL", role: .cancel){}
        }
        .alert(isPresented: $showDisable) {
            Alert(
                title: Text("Disable"),
                message: Text("Are you sure want to disable \(selectedStaff?.name ?? "")?"),
                primaryButton: .default(Text("OK"), action: {
                    viewModel.changeEnable(id: selectedStaff!.id, enable: false)
                }),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showManage) {
            ManageStaffSheet(
                staff: viewModel.getStaffModelBy(id: selectedStaff?.id),
                roles: viewModel.roles,
                projects: viewModel.projects
            ) { model, password in
                viewModel.manageStaff(model: model, password: password)
            }
        }
        .alert(isPresented: $viewModel.exist) {
            Alert(
                title: Text("Sorry"),
                message: Text("Staff name already exist."),
                dismissButton: .cancel()
            )
        }
    }
}

struct StavesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StavesView()
        }
    }
}

extension StavesView {
    private func staffItem(staff: StaffUiModel) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: URL(string: staff.photo)) { image in
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.theme.placeholder)
                        .frame(width: 50, height: 50)
                }
                
                VStack(alignment: .leading) {
                    Text(staff.name)
                        .font(.headline)
                    
                    Text(staff.roleName)
                        .font(.footnote)
                }
            }
            .opacity(staff.enable ? 1 : 0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Divider()
        }
        .background(.black.opacity(0.0001))
    }
}
