//
//  SingleSelectableSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import SwiftUI

struct SingleSelectableSheet<T: Selectable>: View {
    
    @Environment(\.dismiss) var dismiss
    
    let list: [T]
    @Binding var selected: T?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(list, id: \.id) { item in
                    HStack(alignment: .center) {
                        Text(item.name)
                        
                        Spacer()
                        
                        if item.id == selected?.id {
                            Image(systemName: "checkmark")
                                .font(.footnote)
                        }
                    }
                    .padding()
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        selected = item
                        dismiss()
                    }
                    
                    Divider()
                }
                
                Spacer()
            }
        }
        .padding(.top)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct SingleSelectableSheet_Previews: PreviewProvider {
    static let list = [
        LeaveTypeModel(
            id: UUID().uuidString,
            name: "Annual Leave",
            color: 12345678,
            enable: true),
        LeaveTypeModel(
            id: UUID().uuidString,
            name: "Medical Leave",
            color: 87654321,
            enable: true)
    ]
    static var previews: some View {
        SingleSelectableSheet(
            list: list,
            selected: .constant(list.first)
        )
    }
}
