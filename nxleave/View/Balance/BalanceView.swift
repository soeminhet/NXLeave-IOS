//
//  BalanceView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import SwiftUI

struct BalanceView: View {
    
    @AppStorage("uid") var uid: String = ""
    @StateObject private var viewModel = BalanceViewModel()
    @State private var showAddRequestSheet: Bool = false
    @State private var showDetailSheet: Bool = false
    @State private var showError: Bool = false
    @State private var error: String? = nil
    @State private var showLeaveCancel: Bool = false
    @State private var leaveCancel: LeaveRequestUiModel? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0,pinnedViews: [.sectionHeaders]) {
                    myLeavesBalanceCircle
                        .padding(.vertical)
                    
                    LazyVGrid(columns: columns, alignment: .leading) {
                        ForEach(viewModel.leaveTypes.filter{$0.enable}, id: \.id) { type in
                            HStack(alignment: .top) {
                                Circle()
                                    .fill(Color(uiColor: UIColor(fromUInt64: type.color)))
                                    .frame(width: 20)
                                
                                Text(type.name)
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .padding()
                    .background(Color.theme.background)
                    .cornerRadius(10)
                    
                    myLeavesHistoy
                }
            }
            .padding(.top, 1)
            .padding(.horizontal)
            
            addLeaveRequestBtn
                .padding()
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .onAppear{
            viewModel.fetchCurrentStaff(uid: uid)
            viewModel.fetchLeaveTypes()
            viewModel.fetchRoles()
        }
        .sheet(isPresented: $showAddRequestSheet) {
            NewLeaveRequestSheet(
                leaveTypes: viewModel.leaveTypes.filter{ $0.enable }
            ) { request in
                let (isLeaveLeft, error) = viewModel.checkLeaveLeft(leaveTypeId: request.leaveTypeId, duration: request.duration)
                if isLeaveLeft {
                    viewModel.submitRequest(request)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showError = true
                        self.error = error
                    }
                }
            }
        }
        .sheet(isPresented: $showDetailSheet) {
            MyLeaveBalanceSheet(balances: viewModel.myLeaveBalances)
        }
        .alert(
            error ?? "",
            isPresented: $showError
        ) {
            Button("OK", role: .cancel){ error = nil }
        }
        .alert(
            "Leave Cancel",
            isPresented: $showLeaveCancel
        ) {
            Button("NO"){
                showLeaveCancel = false
                leaveCancel = nil
            }
            Button("YES"){
                viewModel.deleteLeaveRequest(with: leaveCancel!.id)
                showLeaveCancel = false
                leaveCancel = nil
            }
        } message: {
            Text("Do you want to cancel \(leaveCancel?.duaration ?? "") \(leaveCancel?.leaveTypeName ?? "")?")
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}

extension BalanceView {
    private var addLeaveRequestBtn: some View {
        Button {
            showAddRequestSheet.toggle()
        } label: {
            NXAddCircle()
        }
    }
    
    private var myLeavesHistoy: some View {
        Section {
            ForEach(viewModel.leaveRequests, id: \.id) { value in
                LeaveRequestItem(request: value)
                    .background(.black.opacity(0.0001))
                    .onTapGesture {
                        if value.leaveStatus == LeaveStatus.Pending {
                            showLeaveCancel = true
                            leaveCancel = value
                        }
                    }
                    .padding(.bottom, 10)
            }
        } header: {
            SectionHeader(title: "My Leaves History")
        }
    }
    
    private var myLeavesBalanceCircle: some View {
        NXCircleProgressView(
            progresses: viewModel.progresses,
            totalDays: viewModel.leftDays
        ) {
            showDetailSheet.toggle()
        }
    }
}
