//
//  ManageLeaveBalanceSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 02/02/2024.
//

import SwiftUI

struct ManageLeaveBalanceSheet: View {
    
    @Environment(\.dismiss) var dismiss
    private var itemModel: LeaveBalanceItemUiModel
    private var initLeaveBalances: [LeaveBalanceManageUiModel]
    private let submit: (LeaveBalanceItemUiModel) -> Void
    @State private var leaveBalances: [LeaveBalanceManageUiModel]
    
    init(leaveBalance: LeaveBalanceItemUiModel, submit: @escaping (LeaveBalanceItemUiModel) -> Void) {
        self.itemModel = leaveBalance
        self.initLeaveBalances = leaveBalance.models
        self._leaveBalances = State(initialValue: leaveBalance.models)
        self.submit = submit
    }
    
    private var buttonDisable: Bool {
        leaveBalances.allSatisfy { balance in
            let initBalance = initLeaveBalances.first{ $0.id == balance.id }?.balance
            return initBalance == balance.balance
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach($leaveBalances, id: \.id) { $balance in
                            NXIntTextField(label: balance.leaveTypeName, value: $balance.balance)
                        }
                    }
                    .padding()
                }
                
                Button {
                    submit(
                        LeaveBalanceItemUiModel(
                            id: itemModel.id,
                            roleName: itemModel.roleName,
                            models: leaveBalances
                        )
                    )
                    dismiss()
                } label: {
                    Text("SUBMIT")
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                }
                .disabled(buttonDisable)
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Edit \(itemModel.roleName)")
            .presentationDragIndicator(.visible)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ManageLeaveBalanceSheet_Previews: PreviewProvider {
    static var previews: some View {
        ManageLeaveBalanceSheet(leaveBalance: LeaveBalanceItemUiModel(id: "", roleName: "Admin", models: [
            LeaveBalanceManageUiModel(
                id: "1",
                roleId: "",
                leaveTypeId: "",
                leaveTypeName: "Annual Leave",
                balance: 0
            ),
            LeaveBalanceManageUiModel(
                id: "2",
                roleId: "",
                leaveTypeId: "",
                leaveTypeName: "Medical Leave",
                balance: 0
            )
        ])) { _ in
            
        }
    }
}
