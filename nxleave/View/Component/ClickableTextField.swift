//
//  ClickableTextField.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import SwiftUI

struct ClickableTextField: View {
    
    let label: String
    let placeholder: String
    let text: String
    let click: () -> Void
    
    init(label: String = "", placeholder: String = "", text: String, click: @escaping () -> Void) {
        self.label = label
        self.text = text
        self.placeholder = placeholder
        self.click = click
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !label.isEmpty {
                Text(label)
                    .font(.caption)
                    .padding(.bottom, 10)
            }
            
            Button {
                click()
            } label: {
                Text(text.isEmpty ? placeholder : text)
                    .opacity(text.isEmpty ? 0.3 : 1)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 55)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.theme.blackVarient.opacity(0.8), lineWidth: 1)
                    }
            }
        }
    }
}

struct ClickableTextField_Previews: PreviewProvider {
    static var previews: some View {
        ClickableTextField(
            label: "Label", placeholder: "Placeholder", text: ""
        ) {
            
        }
        .previewLayout(.sizeThatFits)
    }
}
