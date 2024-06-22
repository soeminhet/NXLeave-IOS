//
//  LeaveTypesView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 30/01/2024.
//

import SwiftUI

struct LeaveTypesView: View {
    
    @StateObject private var viewModel = LeaveTypesViewModel()
    @State private var showManageOption: Bool = false
    @State private var selectedLeaveType: LeaveTypeModel? = nil
    @State private var showManage: Bool = false
    @State private var showDisable: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.leaveTypes, id: \.id) { type in
                        LeaveType(color: type.color, name: type.name, enable: type.enable)
                            .onTapGesture {
                                showManageOption.toggle()
                                selectedLeaveType = type
                            }
                    }
                }
            }
            
            Button {
                showManage.toggle()
                selectedLeaveType = nil
            } label: {
                NXAddCircle()
            }
            .padding()
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .animation(.default, value: viewModel.loading)
        .navigationTitle("LeaveTypes")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchLeaveTypes()
        }
        .confirmationDialog("", isPresented: $showManageOption) {
            Button("Edit"){ showManage.toggle() }
            
            if selectedLeaveType?.enable == true {
                Button("Disable", role: .destructive){
                    showDisable.toggle()
                }
            } else {
                Button("Enable"){
                    let leaveType = selectedLeaveType!.changeEnable(enable: true)
                    viewModel.manageLeaveType(model: leaveType)
                }
            }
            
            Button("CANCEL", role: .cancel){}
        }
        .sheet(isPresented: $showManage) {
            ManageLeaveTypeSheet(leaveType: selectedLeaveType) { leaveType in
                viewModel.manageLeaveType(model: leaveType)
            }
        }
        .alert(isPresented: $showDisable) {
            Alert(
                title: Text("Disable"),
                message: Text("Are you sure want to disable \(selectedLeaveType?.name ?? "")?"),
                primaryButton: .default(Text("OK"), action: {
                    let leaveType = selectedLeaveType!.changeEnable(enable: false)
                    viewModel.manageLeaveType(model: leaveType)
                }),
                secondaryButton: .cancel()
            )
        }
        .alert(isPresented: $viewModel.exist) {
            Alert(
                title: Text("Sorry"),
                message: Text("LeaveType name already exist."),
                dismissButton: .cancel()
            )
        }
    }
}

struct LeaveTypesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LeaveTypesView()
        }
    }
}

extension LeaveTypesView {
    private func LeaveType(color: UInt64, name: String, enable: Bool) -> some View {
        VStack(spacing: 0) {
            HStack {
                Circle()
                    .fill(Color(uiColor: UIColor(fromUInt64: color)))
                    .frame(width: 25, height: 25)
                    .opacity(enable ? 1 : 0.5)
                
                Text(name)
                    .padding(.leading, 4)
                    .opacity(enable ? 1 : 0.5)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
        }
    }
}
