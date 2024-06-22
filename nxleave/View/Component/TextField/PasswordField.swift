//
//  PasswordField.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//

import SwiftUI

private enum FocusElement: Hashable {
    case hide
    case show
}

struct PasswordField: View {
    
    @Binding var password: String
    @State private var hidePassword: Bool = true
    @FocusState private var focus: FocusElement?
    private var isPasswordValid: Bool {
        password.isEmpty ? true : password.isValidPassword
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                securefield
                
                Button {
                    hidePassword.toggle()
                    focus = hidePassword ? .hide : .show
                } label: {
                    Image(systemName: hidePassword ? "eye.slash" : "eye")
                        .accentColor(.gray)
                }
                .padding(.trailing)
            }
            
            if !isPasswordValid {
                Text("Password must be at least 8 letters and include uppercase, lowercase, non-alphanumeric letter.")
                    .font(.caption)
                    .foregroundColor(Color.theme.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(
            password: .constant("")
        )
    }
}

extension PasswordField {
    private var securefield: some View {
        Group {
            SecureField(
                "Password",
                text: $password
            )
            .textInputAutocapitalization(.never)
            .keyboardType(.asciiCapable)
            .padding()
            .frame(height: 55)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.theme.accent.opacity(0.8), lineWidth: 1)
            }
            .opacity(hidePassword ? 1 : 0)
            .focused($focus, equals: .hide)
            
            TextField(
                "Password",
                text: $password
            )
            .textInputAutocapitalization(.never)
            .keyboardType(.asciiCapable)
            .padding()
            .frame(height: 55)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.theme.accent.opacity(0.8), lineWidth: 1)
            }
            .opacity(hidePassword ? 0 : 1)
            .focused($focus, equals: .show)
        }
    }
}
