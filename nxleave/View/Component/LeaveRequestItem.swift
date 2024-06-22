//
//  LeaveRequestItem.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import SwiftUI

struct LeaveRequestItem: View {
    
    let request: LeaveRequestUiModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            RoundedRectangle(cornerRadius: 0)
                .fill(request.leaveStatus.color)
                .frame(width: 8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(request.name)
                    .font(.headline)
                    .fontWeight(.medium)
                
                HStack {
                    Image(systemName: "calendar")
                    Text(request.dateRange)
                }
                .foregroundColor(request.leaveStatus.color)
                .font(.subheadline)
                
                if !request.roleName.isEmpty {
                    Text(request.roleName)
                        .font(.footnote)
                        .fontWeight(.light)
                }
                
                Text(request.leaveTypeName)
                    .font(.footnote)
                    .fontWeight(.light)
            }
            .padding(.leading, 12)
            .padding(.vertical, 12)
            
            Spacer()
            
            LeaveStatusChip(status: request.leaveStatus)
                .padding(.trailing, 12)
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.theme.white)
        .cornerRadius(10)
    }
}

struct LeaveRequestItem_Previews: PreviewProvider {
    static var previews: some View {
        LeaveRequestItem(
            request: LeaveRequestUiModel(
                id: "",
                name: "Admin",
                roleName: "Admin",
                dateRange: "12 Dec 2023 - 15 Dec 2023",
                leaveTypeName: "Annual Leave",
                leaveStatus: LeaveStatus.Approved,
                duaration: "4 Days"
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
