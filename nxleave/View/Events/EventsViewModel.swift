//
//  EventsViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//
import Combine
import Foundation

@MainActor class EventsViewModel: ObservableObject {
    
    private let firestoreService = FirestoreService()
    @Published var loading: Bool = false
    @Published var events: [EventModel] = []
    @Published var exist: Bool = false
    
    func fetchEvents() async {
        loading = true
        do {
            events = try await firestoreService.getAllEvents().sorted{ $0.date < $1.date }
        } catch(let error) {
            print(error.localizedDescription)
        }
        loading = false
    }
    
    func deleteEvent(model: EventModel) {
        loading = true
        Task {
            do {
                try await firestoreService.deleteEventBy(model: model)
                Task{ await fetchEvents() }
            } catch(let error) {
                loading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func manageEvent(model: EventModel) {
        loading = true
        if model.id.isEmpty {
            if(checkExist(model: model, models: events)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            addEvent(model: model)
        } else {
            if(nameChanged(model: model, models: events) && checkExist(model: model, models: events)) {
                loading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.exist = true
                }
                return
            }
            updateEvent(model: model)
        }
        Task{ await fetchEvents() }
    }
    
    private func updateEvent(model: EventModel) {
        print("UPDATE")
        do {
            try firestoreService.updateEventBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func addEvent(model: EventModel) {
        print("ADD")
        do {
            try firestoreService.addEventBy(model: model)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
