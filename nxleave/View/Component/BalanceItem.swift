//
//  BalanceItem.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 02/02/2024.
//

import SwiftUI

struct BalanceItem: View {
    
    private let roleName: String
    private let models: [LeaveBalanceManageUiModel]
    init(roleName: String, models: [LeaveBalanceManageUiModel]) {
        self.roleName = roleName
        self.models = models
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(roleName)
                
                Spacer()
                
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit")
                }
            }
            .font(.callout)
            .fontWeight(.semibold)
            .padding()
            
            Divider()
            
            VStack(spacing: 10) {
                ForEach(models, id: \.id) { model in
                    HStack {
                        Text(model.leaveTypeName)
                        Spacer()
                        Text(String(model.balance).toDays())
                            .fontWeight(.semibold)
                    }
                    .font(.callout)
                }
            }
            .padding()
            
        }
        .background(Color.theme.white)
        .cornerRadius(10)
    }
}

struct BalanceItem_Previews: PreviewProvider {
    static var previews: some View {
        BalanceItem(
            roleName: "Admin",
            models: [
                LeaveBalanceManageUiModel(id: "", roleId: "", leaveTypeId: "", leaveTypeName: "Annual Leave", balance: 0)
            ]
        )
        .previewLayout(.sizeThatFits)
    }
}
