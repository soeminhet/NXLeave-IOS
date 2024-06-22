//
//  ManageStaffSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//

import SwiftUI

struct ManageStaffSheet: View {
    
    let staff: StaffModel?
    let roles: [RoleModel]
    let projects: [ProjectModel]
    let submit: (StaffModel, String) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedRole: RoleModel? = nil
    @State private var selectedProjects: [ProjectModel] = []
    @State private var showRole: Bool = false
    @State private var showProjects: Bool = false
    private var roleName: String {
        roles.first{ $0.id == selectedRole?.id }?.name ?? ""
    }
    private var projectNames: String {
        selectedProjects.map{ $0.name }.joined(separator: ", ")
    }
    private var buttonDisable: Bool {
        name.isEmpty || !email.isValidEmail || phoneNumber.isEmpty || roleName.isEmpty || projectNames.isEmpty || (staff != nil ? false : !password.isValidPassword)
    }
    
    init(staff: StaffModel?, roles: [RoleModel], projects: [ProjectModel], submit: @escaping (StaffModel, String) -> Void) {
        self.staff = staff
        self.roles = roles
        self.projects = projects
        self.submit = submit
        
        self._name = State(initialValue: staff?.name ?? "")
        self._email = State(initialValue: staff?.email ?? "")
        self._phoneNumber = State(initialValue: staff?.phoneNumber ?? "")
        
        if let staffRoleId = staff?.roleId,
           let role = roles.first(where: { $0.id == staffRoleId }) {
            self._selectedRole = State(initialValue: role)
        }
        
        if let staffProjectIds = staff?.currentProjectIds {
            let staffProjects = projects.filter{ p in staffProjectIds.contains{ $0 == p.id }}
            self._selectedProjects = State(initialValue: staffProjects)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(staff == nil ? "ADD STAFF" : "EDIT STAFF")
                .font(.title2)
                .padding(.vertical)
            
            NXTextField("Name", text: $name)
            
            EmailField(email: $email)
            
            if staff == nil {
                PasswordField(password: $password)
            }
            
            NXTextField("PhoneNumber", text: $phoneNumber)
                .keyboardType(.phonePad)
            
            ClickableTextField(placeholder: "Role", text: roleName) {
                showRole.toggle()
            }
            
            ClickableTextField(placeholder: "Projects", text: projectNames) {
                showProjects.toggle()
            }
            
            Spacer()
            
            Button {
                submit(
                    StaffModel(
                        id: staff?.id ?? "",
                        roleId: selectedRole!.id,
                        name: name,
                        email: email,
                        phoneNumber: phoneNumber,
                        currentProjectIds: selectedProjects.map{ $0.id },
                        photo: staff?.photo ?? "",
                        enable: staff?.enable ?? true
                    ),
                    password
                )
                dismiss()
            } label: {
                Text(staff == nil ? "SUBMIT" : "UPDATE")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .disabled(buttonDisable)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showRole) {
            SingleSelectableSheet(list: roles, selected: $selectedRole)
        }
        .sheet(isPresented: $showProjects) {
            MultiSelectableSheet(list: projects, selected: selectedProjects) { projects in
                selectedProjects = projects
            }
        }
    }
}

struct ManageStaffSheet_Previews: PreviewProvider {
    static var previews: some View {
        ManageStaffSheet(staff: nil, roles: [], projects: [], submit: {_,_ in})
    }
}
