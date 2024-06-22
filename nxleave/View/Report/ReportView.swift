//
//  ReportView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 04/02/2024.
//

import SwiftUI

struct ReportView: View {
    
    @StateObject private var viewModel = ReportViewModel()
    @State private var showFilter: Bool = false
    @State private var showExcel: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.leaveRequests, id: \.id) { request in
                        LeaveRequestItem(request: request)
                    }
                }
                .padding()
            }
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .animation(.default, value: viewModel.loading)
        .navigationTitle("Report")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadData()
        }
        .toolbar {
            Image(systemName: "printer")
                .padding()
                .onTapGesture {
                    showExcel.toggle()
                }
            Image(systemName: "line.3.horizontal.decrease.circle")
                .onTapGesture {
                    showFilter.toggle()
                }
        }
        .sheet(isPresented: $showFilter) {
            FilterReportSheet(
                staves: viewModel.staves,
                roles: viewModel.roles,
                projects: viewModel.projects,
                startDate: viewModel.startDate,
                endDate: viewModel.endDate) { staff, role, project, startDate, endDate in
                    Task {
                        await viewModel.filterLeaveRequest(staffModel: staff, roleModel: role, projectModel: project, startDate: startDate, endDate: endDate)
                    }
                }
        }
        .alert("Coming soon!", isPresented: $showExcel) {
            Button("OK", role: .cancel){}
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReportView()
        }
    }
}
