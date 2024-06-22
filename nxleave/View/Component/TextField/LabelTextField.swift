//
//  LabelTextField.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import SwiftUI

struct LabelTextField: View {
    
    let label: String
    let lineLimit: Int
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.caption)
            
            TextField(
                "",
                text: $value,
                axis: .vertical
            )
            .lineLimit(lineLimit, reservesSpace: true)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.theme.blackVarient.opacity(0.8), lineWidth: 1)
            }
        }
    }
}

struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextField(
            label: "Description",
            lineLimit: 1,
            value: .constant("")
        )
        .previewLayout(.sizeThatFits)
    }
}
