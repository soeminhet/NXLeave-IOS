//
//  ApproveView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 28/01/2024.
//

import SwiftUI

struct ApproveView: View {
    
    @AppStorage("uid") var uid: String = ""
    @StateObject private var viewModel = ApproveViewModel()
    @Namespace var tabNameSpace
    @State private var leaveDetail: LeaveRequestDetailUiModel? = nil
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    ForEach(LeaveStatus.allCases, id: \.rawValue) { status in
                        Button {
                            viewModel.currentTab = status
                        } label: {
                            VStack {
                                Text(status.rawValue)
                                
                                if viewModel.currentTab == status {
                                    Color.black
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "underline", in: tabNameSpace)
                                } else {
                                    Color.clear
                                        .frame(height: 2)
                                }
                            }
                            .animation(.spring(), value: viewModel.currentTab)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 0.5)
                .background(alignment: .bottom) {
                    Color.gray
                        .frame(height: 0.5)
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.filteredLeaveRequests, id: \.id) { request in
                            LeaveRequestItem(request: request)
                                .onTapGesture {
                                    Task {
                                        leaveDetail = await viewModel.getLeaveDetail(by: request.id)
                                    }
                                }
                        }
                    }
                    .padding(.all)
                }
            }
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .onAppear {
            viewModel.fetchCurrentStaff(uid: uid)
            viewModel.fetchRoles()
            viewModel.fetchLeaveTypes()
        }
        .sheet(item: $leaveDetail) { detail in
            LeaveRequestDetailSheet(
                detail: detail,
                approve: { viewModel.leaveStatusUpdate(id: detail.id, status: LeaveStatus.Approved) },
                reject: { viewModel.leaveStatusUpdate(id: detail.id, status: LeaveStatus.Rejected) }
            )
        }
    }
}

struct ApproveView_Previews: PreviewProvider {
    static var previews: some View {
        ApproveView()
    }
}
