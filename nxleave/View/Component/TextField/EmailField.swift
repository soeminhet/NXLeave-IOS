//
//  EmailField.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//

import SwiftUI

struct EmailField: View {
    
    @Binding var email: String
    private var isEmailValid: Bool {
        email.isEmpty ? true : email.isValidEmail
    }
    
    var body: some View {
        VStack {
            TextField(
                "Email",
                text: $email
            )
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .padding()
            .frame(height: 55)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.theme.blackVarient.opacity(0.8), lineWidth: 1)
            }
            
            if !isEmailValid {
                Text("Email invalid")
                    .font(.caption)
                    .foregroundColor(Color.theme.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct EmailField_Previews: PreviewProvider {
    static var previews: some View {
        EmailField(email: .constant("g"))
    }
}
