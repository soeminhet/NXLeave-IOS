//
//  OnboardView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 22/01/2024.
//

import SwiftUI

struct OnboardView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel = OnboardViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("NXLeave")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.blackVarient)
                
                Text("Take flight from paperwork.")
                    .font(.caption)
                    .foregroundColor(Color.theme.blackVarient)
                
                Spacer()
                
                Button {
                    if viewModel.isInitialized {
                        router.navigate(to: "Login")
                    } else {
                        viewModel.getStarted()
                    }
                } label: {
                    Text(viewModel.isInitialized ? "LOGIN" : "GET STARTED")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .animation(.default, value: viewModel.loading)
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.fetchIsInitialized()
        }
        .onChange(of: viewModel.startedSuccess) { newValue in
            if newValue {
                router.navigate(to: "BottomTab")
            }
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
            .environmentObject(Router())
    }
}
