//
//  LeaveStatusChip.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import SwiftUI

struct LeaveStatusChip: View {
    
    let status: LeaveStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(status.color)
            }
    }
}

struct LeaveStatusChip_Previews: PreviewProvider {
    static var previews: some View {
        LeaveStatusChip(status: LeaveStatus.Approved)
            .previewLayout(.sizeThatFits)
    }
}
