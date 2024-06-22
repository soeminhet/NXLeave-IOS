//
//  FilterReportSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 04/02/2024.
//

import SwiftUI

struct FilterReportSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var staff: StaffModel? = allStaff
    @State private var role: RoleModel? = allRole
    @State private var project: ProjectModel? = allProject
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var showStaff: Bool = false
    @State private var showRole: Bool = false
    @State private var showProject: Bool = false
    @State private var showStartDate: Bool = false
    @State private var showEndDate: Bool = false
    
    let staves: [StaffModel]
    let roles: [RoleModel]
    let projects: [ProjectModel]
    let apply: (StaffModel, RoleModel, ProjectModel, Date, Date) -> Void
    
    init(
        staves: [StaffModel],
        roles: [RoleModel],
        projects: [ProjectModel],
        startDate: Date,
        endDate: Date,
        apply: @escaping (StaffModel, RoleModel, ProjectModel, Date, Date) -> Void
    ) {
        self.staves = staves
        self.roles = roles
        self.projects = projects
        self._startDate = State(initialValue: startDate)
        self._endDate = State(initialValue: endDate)
        self.apply = apply
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ClickableTextField(label: "Staff", text: staff?.name ?? "") {
                showStaff.toggle()
            }
            
            if staff?.id.isEmpty == true {
                ClickableTextField(label: "Role", text: role?.name ?? "") {
                    showRole.toggle()
                }
                
                ClickableTextField(label: "Project", text: project?.name ?? "") {
                    showProject.toggle()
                }
            }
            
            ClickableTextField(label: "StartDate", text: startDate.format(with: .dayMonthYear)) {
                showStartDate.toggle()
            }
            
            ClickableTextField(label: "EndDate", text: endDate.format(with: .dayMonthYear)) {
                showEndDate.toggle()
            }
            
            Spacer()
            
            Button {
                apply(staff!, role!, project!, startDate, endDate)
                dismiss()
            } label: {
                Text("APPLY")
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showStaff) {
            SingleSelectableSheet(list: staves, selected: $staff)
        }
        .sheet(isPresented: $showRole) {
            SingleSelectableSheet(list: roles, selected: $role)
        }
        .sheet(isPresented: $showProject) {
            SingleSelectableSheet(list: projects, selected: $project)
        }
        .sheet(isPresented: $showStartDate) {
            DatePicker(
                "StartDate",
                selection: $startDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showEndDate) {
            DatePicker(
                "EndDate",
                selection: $endDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}

struct FilterReportSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilterReportSheet(staves: [], roles: [], projects: [], startDate: Date(), endDate: Date()) { _, _, _, _, _ in
            
        }
    }
}
