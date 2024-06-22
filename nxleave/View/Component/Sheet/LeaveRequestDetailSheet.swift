//
//  LeaveRequestDetailSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 28/01/2024.
//

import SwiftUI

struct LeaveRequestDetailSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    let detail: LeaveRequestDetailUiModel
    let approve: () -> Void
    let reject: () -> Void
    
    init(detail: LeaveRequestDetailUiModel, approve: @escaping () -> Void, reject: @escaping () -> Void) {
        self.detail = detail
        self.approve = approve
        self.reject = reject
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VerticalLabel(
                label: "Name",
                text: detail.name,
                showDivider: false
            )
            
            VerticalLabel(
                label: "Role",
                text: detail.roleName,
                showDivider: false
            )
            
            VStack(alignment: .leading, spacing: 0) {
                VerticalLabel(
                    label: "Start Date",
                    text: detail.startDate,
                    showDivider: false
                )
                
                VerticalLabel(
                    label: "End Date",
                    text: detail.endDate,
                    showDivider: false
                )
                
                VerticalLabel(
                    label: "Apply Date",
                    text: detail.applyDate,
                    showDivider: false
                )
                
                if !detail.approveDate.isEmpty {
                    VerticalLabel(
                        label: "Approve Date",
                        text: detail.approveDate,
                        showDivider: false
                    )
                }
                
                if !detail.rejectedDate.isEmpty {
                    VerticalLabel(
                        label: "Reject Date",
                        text: detail.rejectedDate,
                        showDivider: false
                    )
                }
            }
            
            if !detail.approver.isEmpty {
                VerticalLabel(
                    label: "Approver",
                    text: detail.approver,
                    showDivider: false
                )
            }
            
            if !detail.currentProjects.isEmpty {
                VerticalLabel(
                    label: "Current Projects",
                    text: detail.currentProjects,
                    showDivider: false
                )
            }
            
            VerticalLabel(
                label: "Leave Type",
                text: detail.leaveTypeName,
                showDivider: false
            )
            
            VerticalLabel(
                label: "Leave Status",
                text: detail.leaveStatus.rawValue,
                showDivider: false
            )
            
            Spacer()
            
            Divider()
                .padding(.top)
            
            VStack(spacing: 16) {
                if detail.leaveStatus == .Pending {
                    Button {
                        approve()
                        dismiss()
                    } label: {
                        Text("APPROVE")
                            .frame(maxWidth: .infinity)
                    }
                    .tint(Color.theme.green)
                    .buttonStyle(.borderedProminent)
                
                
                    Button {
                        reject()
                        dismiss()
                    } label: {
                        Text("REJECT")
                            .frame(maxWidth: .infinity)
                    }
                    .tint(Color.theme.red)
                    .buttonStyle(.borderedProminent)
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("CLOSE")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top)
        .presentationDragIndicator(.visible)
    }
}

struct LeaveRequestDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        LeaveRequestDetailSheet(
            detail: LeaveRequestDetailUiModel(
                id: "",
                name: "Soe Min Htet",
                roleName: "Android Developer",
                startDate: "12 Dec 2023",
                endDate: "12 Dec 2023",
                applyDate: "12 Dec 2023",
                approveDate: "",
                rejectedDate: "",
                approver: "",
                currentProjects: "PLC",
                leaveTypeName: "Annual Leave",
                leaveStatus: LeaveStatus.Pending
            ),
            approve: {},
            reject: {}
        )
    }
}
