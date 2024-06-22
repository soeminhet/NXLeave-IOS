//
//  AssignedTeamView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//

import SwiftUI

struct AssignedTeamView: View {
    
    @StateObject private var viewModel = AssignedTeamViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.teams, id: \.self) { team in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(team)
                                .padding()
                            
                            Divider()
                        }
                    }
                }
            }
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .navigationTitle("AssignedTeam")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: viewModel.loading)
        .task {
            await viewModel.fetchStaffProjects()
        }
    }
}

struct AssignedTeamView_Previews: PreviewProvider {
    static var previews: some View {
        AssignedTeamView()
    }
}
