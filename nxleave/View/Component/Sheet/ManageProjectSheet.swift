//
//  ManageProjectSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 31/01/2024.
//

import SwiftUI

struct ManageProjectSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var projectName: String = ""
    private var buttonDisable: Bool {
        projectName.isEmpty || project?.name == projectName
    }
    
    let project: ProjectModel?
    private let submit: (ProjectModel) -> Void
    init(project: ProjectModel?, submit: @escaping (ProjectModel) -> Void) {
        self.project = project
        self.submit = submit
        self._projectName = State(initialValue: project?.name ?? "")
    }
    
    var body: some View {
        VStack {
            Text(project == nil ? "ADD PROJECT" : "EDIT PROJECT")
                .font(.title2)
                .padding(.vertical)
            
            NXTextField("Project", text: $projectName)
            
            Spacer()
            
            Button {
                submit(
                    ProjectModel(
                        id: project?.id ?? "",
                        name: projectName,
                        enable: project?.enable ?? true
                    )
                )
                dismiss()
            } label: {
                Text(project == nil ? "SUBMIT" : "UPDATE")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .disabled(buttonDisable)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium])
    }
}

struct ManageProjectSheet_Previews: PreviewProvider {
    static var previews: some View {
        ManageProjectSheet(project: nil) {_ in }
    }
}
