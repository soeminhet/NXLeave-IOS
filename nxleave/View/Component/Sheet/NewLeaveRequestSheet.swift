//
//  NewLeaveRequestSheet.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 26/01/2024.
//

import SwiftUI

struct NewLeaveRequestSheet: View {
    
    let leaveTypes: [LeaveTypeModel]
    let submit: (LeaveRequestModel) -> Void
    
    init(leaveTypes: [LeaveTypeModel], submit: @escaping (LeaveRequestModel) -> Void) {
        self.leaveTypes = leaveTypes
        self.submit = submit
    }
    
    @AppStorage("uid") var uid = ""
    @Environment(\.dismiss) var dismiss
    
    @State private var leaveType: LeaveTypeModel? = nil
    @State private var startDatePicker: Date = Date()
    @State private var startDate: Date? = nil
    @State private var endDatePicker: Date = Date()
    @State private var endDate: Date? = nil
    @State private var description: String = ""
    @State private var period: PeriodModel? = nil
    @State private var isHalfDay: Bool = false
    
    @State private var showLeaveTypeSheet: Bool = false
    @State private var showPeriodSheet: Bool = false
    @State private var showStartDateSheet: Bool = false
    @State private var showEndDateSheet: Bool = false
    
    private var endDateError: Bool {
        if startDate == nil || endDate == nil || isHalfDay { return false }
        else { return endDate! < startDate! }
    }
    private var submitDisable: Bool {
        leaveType == nil || startDate == nil || (isHalfDay ? period == nil : endDate == nil) || endDateError
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                ClickableTextField(
                    label: "Leave Type",
                    text: leaveType?.name ?? ""
                ) {
                    showLeaveTypeSheet.toggle()
                }
                
                ClickableTextField(
                    label: "Start Date",
                    text: startDate?.format(with: DatePattern.dayMonthYear) ?? ""
                ) {
                    showStartDateSheet.toggle()
                }
                .onChange(of: startDatePicker) { newValue in
                    showStartDateSheet.toggle()
                    startDate = newValue
                }
                
                Toggle("Half day leave", isOn: $isHalfDay)
                    .toggleStyle(.check)
                
                if isHalfDay {
                    ClickableTextField(
                        label: "AM/PM",
                        text: period?.name ?? ""
                    ) {
                        showPeriodSheet.toggle()
                    }
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        ClickableTextField(
                            label: "End Date",
                            text: endDate?.format(with: DatePattern.dayMonthYear) ?? ""
                        ) {
                            showEndDateSheet.toggle()
                        }
                        .onChange(of: endDatePicker) { newValue in
                            showEndDateSheet.toggle()
                            endDate = newValue
                        }
                        
                        if endDateError {
                            Text("End Date must be after start date")
                                .font(.footnote)
                                .foregroundColor(Color.theme.red)
                                .padding(.top, 4)
                        }
                    }
                    .animation(.default, value: endDateError)
                }
                
                LabelTextField(
                    label: "Description",
                    lineLimit: 5,
                    value: $description
                )
                
                Spacer()
                
                Button {
                    let duration = isHalfDay ? 0.5 : Double(Calendar.current.dateComponents([.day], from: startDate!, to: endDate!).day ?? 0) + 1
                    let leaveEndDate = isHalfDay ? startDate : endDate!
                    let request = LeaveRequestModel(
                        id: "",
                        staffId: uid,
                        leaveTypeId: leaveType!.id,
                        approverId: "",
                        duration: String(duration),
                        startDate: startDate!,
                        endDate: leaveEndDate,
                        period: period?.id,
                        description: description,
                        leaveStatus: LeaveStatus.Pending,
                        leaveApplyDate: Date(),
                        leaveApprovedDate: nil,
                        leaveRejectedDate: nil
                    )
                    submit(request)
                    dismiss()
                } label: {
                    Text("SUBMIT")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .disabled(submitDisable)
                
            }
            .padding()
            .navigationTitle("LeaveRequest")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.callout)
                }
            }
            .sheet(isPresented: $showLeaveTypeSheet) {
                SingleSelectableSheet(
                    list: leaveTypes,
                    selected: $leaveType
                )
            }
            .sheet(isPresented: $showPeriodSheet) {
                SingleSelectableSheet(
                    list: periods,
                    selected: $period
                )
            }
            .sheet(isPresented: $showStartDateSheet) {
                DatePicker(
                    "StartDate",
                    selection: $startDatePicker,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showEndDateSheet) {
                DatePicker(
                    "EndDate",
                    selection: $endDatePicker,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

struct NewLeaveRequestSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewLeaveRequestSheet(
            leaveTypes: [
                LeaveTypeModel(
                    id: UUID().uuidString,
                    name: "Annual Leave",
                    color: 12345678,
                    enable: true),
                LeaveTypeModel(
                    id: UUID().uuidString,
                    name: "Medical Leave",
                    color: 87654321,
                    enable: true)
            ]
        ) { model in
            
        }
    }
}
