//
//  UpcomingEventsViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import Combine
import Foundation

@MainActor class UpcomingEventsViewModel: ObservableObject {
    
    private var fetchTask: Task<(), Never>? = nil
    
    private let firestoreService = FirestoreService()
    
    @Published var loading: Bool = false
    @Published var events: [EventModel] = []
    
    init() {
        fetchTask = Task {
            await fetchUpcomingEvents()
        }
    }
    
    private func fetchUpcomingEvents() async {
        loading = true
        do {
            events = try await firestoreService.getAllUpcomingEvents()
        } catch(let error) {
            print(error.localizedDescription)
        }
        loading = false
    }
    
    deinit {
        fetchTask?.cancel()
    }
}
