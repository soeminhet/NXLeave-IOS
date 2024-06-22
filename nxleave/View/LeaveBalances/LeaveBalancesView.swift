//
//  LeaveBalancesView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 02/02/2024.
//

import SwiftUI

struct LeaveBalancesView: View {
    
    @StateObject private var viewModel = LeaveBalancesViewModel()
    @State private var showEditSheet: Bool = false
    @State private var selectedBalances: LeaveBalanceItemUiModel? = nil
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.leaveBalances, id: \.roleName) { balance in
                        BalanceItem(roleName: balance.roleName, models: balance.models)
                            .onTapGesture {
                                selectedBalances = balance
                            }
                    }
                }
                .padding()
            }
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .animation(.default, value: viewModel.loading)
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchLeaveBalances()
        }
        .sheet(item: $selectedBalances) { balance in
            ManageLeaveBalanceSheet(leaveBalance: balance) { itemModel in
                viewModel.manageLeaveBalances(item: itemModel)
            }
        }
    }
}

struct LeaveBalancesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LeaveBalancesView()
        }
    }
}
