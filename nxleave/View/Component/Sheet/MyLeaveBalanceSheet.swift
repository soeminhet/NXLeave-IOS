//
//  MyLeaveBalanceSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import SwiftUI

struct MyLeaveBalanceSheet: View {
    
    let balances: [LeaveBalanceUiModel]
    
    var body: some View {
        VStack {
            HStack {
                Text("Leave Type")
                
                Spacer()
                
                Text("Took")
                    .frame(width: 50, alignment: .trailing)
                
                Text("Total")
                    .frame(width: 50, alignment: .trailing)
            }
            .fontWeight(.semibold)
            .padding(.top, 30)
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 6)
        
            ForEach(balances, id: \.id) { balance in
                HStack(alignment: .center) {
                    Color(uiColor: UIColor(fromUInt64: balance.color))
                        .frame(width: 22, height: 22)
                        .clipShape(Circle())
                    
                    Text(balance.name)
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Text(balance.took.formatDouble())
                        .frame(width: 50, alignment: .trailing)
                    
                    Text(balance.total.formatDouble())
                        .frame(width: 50, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
            }
            
            Spacer()
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct MyLeaveBalanceSheet_Previews: PreviewProvider {
    static var previews: some View {
        MyLeaveBalanceSheet(
            balances: [
                LeaveBalanceUiModel(
                    id: UUID().uuidString,
                    color: 12345678,
                    name: "Annual Leave",
                    took: 5,
                    total: 15,
                    enable: true
                )
            ]
        )
    }
}
