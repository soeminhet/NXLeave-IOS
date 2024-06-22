//
//  DashboardView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 23/01/2024.
//

import SwiftUI

struct DashboardView: View {

    @AppStorage("uid") var uid: String = ""
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                header
                
                upcomingEvents
                
                upcomingLeaves
            }
            .padding(.horizontal)
        }
        .onAppear{
            viewModel.loadData(uid: uid)
        }
        .padding(.top, 1)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

extension DashboardView {
    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Hello \(viewModel.staff?.name ?? "")")
                    .font(.caption)
                
                Text("Today, \(Date().format(with: .dayMonth))")
                    .font(.title2)
            }
            
            Spacer()
            
            AsyncImage(url: URL(string: viewModel.staff?.photo ?? "")) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.theme.placeholder)
                    .frame(width: 50, height: 50)
            }
        }
    }
    
    private var upcomingEvents: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(viewModel.events, id: \.id) { event in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(event.date.format(with: .weekDay))
                                .font(.caption2)
                            
                            Text(event.date.format(with: .dayMonthYear))
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text(event.name)
                                .font(.footnote)
                        }
                        .padding(.all, 10)
                        .frame(width: 150, alignment: .leading)
                        .background(Color.theme.white)
                        .cornerRadius(10)
                        
                    }
                }
            }
            .frame(height: 100)
            .padding(.bottom, 10)
        } header: {
            SectionHeader(title: "Upcoming Holidays") {
                router.navigate(to: "UpcomingEvents")
            }
        }
    }
    
    private var upcomingLeaves: some View {
        Section {
            ForEach(viewModel.leaveRequests, id: \.id) { value in
                LeaveRequestItem(request: value)
                    .padding(.bottom, 10)
            }
        } header: {
            SectionHeader(title: "Upcoming Leaves")
        }
    }
}


