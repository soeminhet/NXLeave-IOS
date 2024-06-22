//
//  ManageLeaveTypeSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 30/01/2024.
//

import SwiftUI

struct ManageLeaveTypeSheet: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let colors = [
        0xFFFF004D,
        0xFF0F1035,
        0xFF80BCBD,
        0xFF525CEB,
        0xFF76453B,
        0xFF607274,
        0xFF49108B,
        0xFFFF90BC,
        0xFF2B2A4C,
        0xFF164863,
        0xFF4F6F52,
        0xFF65B741
    ].map{ UInt64($0) }
    
    @Environment(\.dismiss) var dismiss
    @State private var leaveTypeName = ""
    @State private var leaveTypeColor: UInt64? = nil
    private let leaveType: LeaveTypeModel?
    private let submit: (LeaveTypeModel) -> Void
    private var buttonDisable: Bool {
        leaveTypeName.isEmpty || leaveTypeColor == nil || (leaveType?.name == leaveTypeName && leaveType?.color == leaveTypeColor)
    }
    
    init(leaveType: LeaveTypeModel?, submit: @escaping (LeaveTypeModel) -> Void) {
        self._leaveTypeName = State(initialValue: leaveType?.name ?? "")
        self._leaveTypeColor = State(initialValue: leaveType?.color)
        self.leaveType = leaveType
        self.submit = submit
    }
    
    var body: some View {
        VStack {
            Text(leaveType == nil ? "ADD LEAVE TYPE" : "EDIT LEAVE TYPE")
                .font(.title2)
                .padding(.vertical)

            NXTextField("LeaveType", text: $leaveTypeName)
            
            VStack(alignment: .leading) {
                Text("Color")
                    .font(.subheadline)
                
                LazyVGrid(columns: columns) {
                    ForEach(colors, id: \.self) { color in
                        ZStack {
                            Color(uiColor: UIColor(fromUInt64: color))
                                .frame(height: 50)
                            
                            if leaveTypeColor == color {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .onTapGesture {
                            leaveTypeColor = color
                        }
                    }
                }
            }
            .padding(.top)
            
            Spacer()
            
            Button {
                submit(
                    LeaveTypeModel(
                        id: leaveType?.id ?? "",
                        name: leaveTypeName,
                        color: leaveTypeColor!,
                        enable: leaveType?.enable ?? true
                    )
                )
                dismiss()
            } label: {
                Text(leaveType == nil ? "SUBMIT" : "UPDATE")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .disabled(buttonDisable)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationDragIndicator(.visible)
    }
}

struct ManageLeaveTypeSheet_Previews: PreviewProvider {
    static var previews: some View {
        ManageLeaveTypeSheet(leaveType: nil) { _ in
            
        }
    }
}
