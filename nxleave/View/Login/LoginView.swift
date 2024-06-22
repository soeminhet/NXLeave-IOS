//
//  LoginView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 22/01/2024.
//

import SwiftUI

private enum FocusElement: Hashable {
    case hide
    case show
}

struct LoginView: View {
    
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel = LoginViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    private var loginDisable: Bool {
        !email.isValidEmail || !password.isValidPassword
    }
    
    var body: some View {
        ZStack {
            if viewModel.loading {
                NXLoading()
            }
            
            VStack {
                header
                
                EmailField(email: $email)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                PasswordField(password: $password)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                loginBtn
                
                Spacer()
            }
        }
        .onChange(of: viewModel.success) { newValue in
            if(newValue) {
                router.navigate(to: "BottomTab")
            }
        }
        .onChange(of: viewModel.error) { newValue in
            showError = !newValue.isEmpty
        }
        .alert("", isPresented: $showError) {
            Button("OK", role: .cancel){}
        } message: {
            Text(viewModel.error)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
        }
    }
}

extension LoginView {
    private var header: some View {
        VStack {
            Text("NXLeave")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.blackVarient)
            
            Text("Take flight from paperwork.")
                .font(.caption)
                .foregroundColor(Color.theme.blackVarient)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
    }
    
    private var loginBtn: some View {
        Button {
            Task {
                await viewModel.login(email: email, password: password)
            }
        } label: {
            Text("LOGIN")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .buttonStyle(.borderedProminent)
        .disabled(loginDisable)
        .padding()
    }
}
