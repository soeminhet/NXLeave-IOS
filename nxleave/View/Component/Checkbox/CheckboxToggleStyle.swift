//
//  CheckboxToggleStyle.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(lineWidth: 1)
                .frame(width: 20, height: 20)
                .cornerRadius(4)
                .overlay {
                    Image(systemName: configuration.isOn ? "checkmark" : "")
                        .resizable()
                        .frame(width: 10, height: 10)
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
            
            configuration.label
        }
    }
}
