//
//  NXTextField.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//

import SwiftUI

struct NXTextField: View {
    
    let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .keyboardType(.asciiCapable)
            .padding()
            .frame(height: 55)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.theme.accent.opacity(0.8), lineWidth: 1)
            }
    }
}

struct NXTextField_Previews: PreviewProvider {
    static var previews: some View {
        NXTextField("Placeholder", text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}

struct NXIntTextField: View {
    
    let label: String
    @Binding var value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.caption)
            
            TextField(
                "",
                value: $value,
                formatter: NumberFormatter()
            )
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        Color.theme.blackVarient.opacity(0.8),
                        lineWidth: 1
                    )
            }
        }
    }
}

struct NXIntTextField_Previews: PreviewProvider {
    static var previews: some View {
        NXIntTextField(label: "Label", value: .constant(0))
            .previewLayout(.sizeThatFits)
    }
}
