//
//  ManageEventSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 01/02/2024.
//

import SwiftUI

struct ManageEventSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var showDate: Bool = false
    @State private var datePicker: Date = Date()
    @State private var date: Date? = nil
    private var buttonDisable: Bool {
        name.isEmpty || date == nil
    }
    
    private let event: EventModel?
    private let submit: (EventModel) -> Void
    
    init(event: EventModel?, submit: @escaping (EventModel) -> Void) {
        self.event = event
        self._name = State(initialValue: event?.name ?? "")
        self._date = State(initialValue: event?.date)
        self.submit = submit
    }
    
    var body: some View {
        VStack {
            Text(event == nil ? "ADD EVENT" : "EDIT EVENT")
                .font(.title2)
                .padding(.vertical)
            
            NXTextField("Name", text: $name)
            
            ClickableTextField(label: "Date",text: date?.format(with: .dayMonthYear) ?? "") {
                showDate.toggle()
            }
            .padding(.top, 12)
            
            
            Spacer()
            
            Button {
                submit(
                    EventModel(
                        id: event?.id ?? "",
                        name: name,
                        date: date!
                    )
                )
                dismiss()
            } label: {
                Text(event == nil ? "SUBMIT" : "UPDATE")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .disabled(buttonDisable)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium])
        .onChange(of: datePicker) { newValue in
            showDate.toggle()
            date = newValue
        }
        .sheet(isPresented: $showDate) {
            DatePicker(
                "EventDate",
                selection: $datePicker,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}

struct ManageEventSheet_Previews: PreviewProvider {
    static var previews: some View {
        ManageEventSheet(event: nil, submit: {_ in})
    }
}
