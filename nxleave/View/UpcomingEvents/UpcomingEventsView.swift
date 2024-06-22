//
//  UpcomingEventsView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import SwiftUI

struct UpcomingEventsView: View {
    
    @StateObject private var viewModel: UpcomingEventsViewModel = UpcomingEventsViewModel()
    
    init(){}
    
    var body: some View {
        ZStack {
            if viewModel.loading {
                NXLoading()
            }
            
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.events, id: \.id) { event in
                        VerticalLabel(
                            label: event.name,
                            text: event.date.format(with: .dayMonthYear)
                        )
                    }
                }
            }
        }
        .navigationTitle("Upcoming Events")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UpcomingEventsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpcomingEventsView()
        }
    }
}
