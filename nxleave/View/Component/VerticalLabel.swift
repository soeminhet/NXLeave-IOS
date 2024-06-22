//
//  VerticalLabel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import SwiftUI

struct VerticalLabel: View {
    let label: String
    let text: String
    let showDivider: Bool
    
    init(label: String, text: String, showDivider: Bool = true) {
        self.label = label
        self.text = text
        self.showDivider = showDivider
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.headline)
                .padding(.horizontal)
            
            
            Text(text)
                .padding(.horizontal)
            
            if showDivider {
                Divider()
                    .padding(.top, 10)
            }
        }
        .padding(.top, 10)
    }
}

struct VerticalLabel_Previews: PreviewProvider {
    static var previews: some View {
        VerticalLabel(
            label: "Label",
            text: "Text"
        )
        .previewLayout(.sizeThatFits)
    }
}
