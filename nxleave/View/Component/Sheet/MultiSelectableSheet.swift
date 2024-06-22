//
//  MultiSelectableSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//

import SwiftUI

struct MultiSelectableSheet<T: MultiSelectable>: View {
    
    @Environment(\.dismiss) var dismiss
    
    let list: [T]
    let selected: [T]
    let submit: ([T]) -> Void
    @State private var internalSelected: [T] = []
    
    init(list: [T], selected: [T], submit: @escaping ([T]) -> Void) {
        self.list = list
        self.selected = selected
        self.submit = submit
        self._internalSelected = State(initialValue: selected)
    }
    
    private var buttonDisable: Bool {
        internalSelected.isEmpty || internalSelected.allSatisfy{ i in selected.contains{ $0.id == i.id } }
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(list, id: \.id) { item in
                        HStack(alignment: .center) {
                            Text(item.name)
                            
                            Spacer()
                            
                            if internalSelected.contains(where: { $0.id == item.id }) {
                                Image(systemName: "checkmark")
                                    .font(.footnote)
                            }
                        }
                        .padding()
                        .background(.black.opacity(0.001))
                        .onTapGesture {
                            if let index = internalSelected.firstIndex(of: item) {
                                internalSelected.remove(at: index)
                            } else {
                                internalSelected.append(item)
                            }
                        }
                        
                        Divider()
                    }
                }
            }
                
            Spacer()
                
            Button {
                submit(internalSelected)
                dismiss()
            } label: {
                Text("DONE")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .disabled(buttonDisable)
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding(.top)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct MultiSelectableSheet_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectableSheet(
            list: [
                ProjectModel(id: "1", name: "AIA", enable: true),
                ProjectModel(id: "2", name: "TRIFECTA", enable: true),
                ProjectModel(id: "3", name: "PLC", enable: true),
                ProjectModel(id: "4", name: "ZIG", enable: true)
            ], selected: [
                ProjectModel(id: "2", name: "TRIFECTA", enable: true),
                ProjectModel(id: "3", name: "PLC", enable: true)
            ], submit: { _ in }
        )
    }
}
