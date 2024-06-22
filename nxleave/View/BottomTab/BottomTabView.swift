//
//  TabView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import SwiftUI

struct BottomTabView: View {
    
    @AppStorage("uid") var uid = ""
    @StateObject var viewModel = BottomTabViewModel()
    @State private var selection = 0
    
    var body: some View {
        ZStack {
            if viewModel.enable {
                TabView(selection: $selection) {
                    DashboardView()
                        .tabItem {
                            if selection == 0 {
                                Label(
                                    "Dashboard", image: "DashboardIconFill")
                            } else {
                                Label("Dashboard", image: "DashboardIcon")
                            }
                        }
                        .tag(0)
                    
                    BalanceView()
                        .tabItem {
                            Label("Balance", image: "BalanceIcon")
                        }
                        .tag(1)
                    
                    if viewModel.accessLevel != AccessLevel.none {
                        ApproveView()
                            .tabItem {
                                if selection == 2 {
                                    Label("Approve", image: "TaskIconFill")
                                } else {
                                    Label("Approve", image: "TaskIcon")
                                }
                            }
                            .tag(2)
                    }
                    
                    ProfileView()
                        .tabItem {
                            if selection == 3 {
                                Label("Profile", image: "PersonIconFill")
                            } else {
                                Label("Profile", image: "PersonIcon")
                            }
                        }
                        .tag(3)
                }
            } else {
                AccountSuspendView()
            }
        }
        .navigationBarBackButtonHidden()
        .environment(\.accessLevel, viewModel.accessLevel)
        .onAppear {
            viewModel.fetchRole(uid: uid)
        }
        .onChange(of: viewModel.roleId) { newValue in
            viewModel.fetchAccessLeavel(roleId: newValue)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
            .environmentObject(Router())
    }
}
