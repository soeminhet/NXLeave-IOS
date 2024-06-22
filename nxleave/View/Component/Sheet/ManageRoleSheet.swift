//
//  ManageRoleSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//

import SwiftUI

struct ManageRoleSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var roleName = ""
    @State private var selectableAccessLevel: SelectableAccessLevel? = nil
    @State private var showAccessLevelSheet: Bool = false
    private let role: RoleModel?
    private let submit: (RoleModel) -> Void
    private var buttonDisable: Bool {
        roleName.isEmpty || selectableAccessLevel == nil || (role?.name == roleName && role?.accessLevel == selectableAccessLevel?.accessLevel)
    }
    
    init(role: RoleModel?, submit: @escaping (RoleModel) -> Void) {
        self._roleName = State(initialValue: role?.name ?? "")
        if let accessLevel = role?.accessLevel {
            self._selectableAccessLevel = State(initialValue: SelectableAccessLevel(accessLevel: accessLevel))
        }
        self.role = role
        self.submit = submit
    }
    
    var body: some View {
        VStack {
            Text(role == nil ? "ADD ROLE" : "EDIT ROLE")
                .font(.title2)
                .padding(.vertical)
            
            NXTextField("Role", text: $roleName)
            
            ClickableTextField(label: "Level", text: selectableAccessLevel?.name ?? "") {
                showAccessLevelSheet.toggle()
            }
            .padding(.top)
            
            Spacer()
            
            Button {
                submit(
                    RoleModel(
                        id: role?.id ?? "",
                        name: roleName,
                        enable: role?.enable ?? true,
                        accessLevel: selectableAccessLevel!.accessLevel
                    )
                )
                dismiss()
            } label: {
                Text(role == nil ? "SUBMIT" : "UPDATE")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .disabled(buttonDisable)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium])
        .sheet(isPresented: $showAccessLevelSheet) {
            SingleSelectableSheet(
                list: selectableAccessLevels,
                selected: $selectableAccessLevel
            )
        }
    }
}

struct ManageRoleSheet_Previews: PreviewProvider {
    static var previews: some View {
        ManageRoleSheet(role: nil, submit: {_ in })
    }
}
