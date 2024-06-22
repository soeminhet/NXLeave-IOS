//
//  EventsView.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//

import SwiftUI

struct EventsView: View {
    
    @StateObject private var viewModel = EventsViewModel()
    @State private var showManageOption: Bool = false
    @State private var selectedEvent: EventModel? = nil
    @State private var showManage: Bool = false
    @State private var showDelete: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.events, id: \.id) { event in
                        VerticalLabel(
                            label: event.name,
                            text: event.date.format(with: .dayMonthYear)
                        )
                        .background(.black.opacity(0.0001))
                        .onTapGesture {
                            showManageOption.toggle()
                            selectedEvent = event
                        }
                    }
                }
            }
            
            Button {
                showManage.toggle()
                selectedEvent = nil
            } label: {
                NXAddCircle()
            }
            .padding()
            
            if viewModel.loading {
                NXLoading()
            }
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: viewModel.loading)
        .task {
            await viewModel.fetchEvents()
        }
        .confirmationDialog("", isPresented: $showManageOption) {
            Button("Edit"){ showManage.toggle() }
            Button("Delete", role: .destructive){ showDelete.toggle() }
            Button("CANCEL", role: .cancel){}
        }
        .alert(isPresented: $showDelete) {
            Alert(
                title: Text("Delete"),
                message: Text("Are you sure want to delete \(selectedEvent?.name ?? "")?"),
                primaryButton: .destructive(Text("OK"), action: {
                    viewModel.deleteEvent(model: selectedEvent!)
                }),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showManage) {
            ManageEventSheet(event: selectedEvent) { model in
                viewModel.manageEvent(model: model)
            }
        }
        .alert(isPresented: $viewModel.exist) {
            Alert(
                title: Text("Sorry"),
                message: Text("Event name already exist."),
                dismissButton: .cancel()
            )
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
