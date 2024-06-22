//
//  FirestoreService.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

class FirestoreService {
    
    private var db: Firestore
    private var eventCollection: CollectionReference
    private var staffCollection: CollectionReference
    private var leaveTypeCollection: CollectionReference
    private var roleCollection: CollectionReference
    private var leaveRequestCollection: CollectionReference
    private var projectCollection: CollectionReference
    private var leaveBalanceCollection: CollectionReference
    
    init(){
        db = Firestore.firestore()
        eventCollection = db.collection("Event")
        staffCollection = db.collection("Staff")
        leaveTypeCollection = db.collection("LeaveType")
        roleCollection = db.collection("Role")
        leaveRequestCollection = db.collection("LeaveRequest")
        projectCollection = db.collection("Project")
        leaveBalanceCollection = db.collection("LeaveBalance")
    }
    
    func isInitialized() async throws -> Bool {
        let staves = try await staffCollection.getDocuments()
        return staves.count > 0
    }
    
    func getAllEvents() async throws -> [EventModel] {
        return try await eventCollection
            .getDocuments()
            .decodeArray()
    }
    
    func getAllUpcomingEvents() async throws -> [EventModel] {
        let today = getTodayStartTimeStamp()
        return try await eventCollection
            .order(by: "date")
            .start(at: [today])
            .getDocuments()
            .decodeArray()
    }
    
    func getAllUpcomingEvents(with limit: Int) async throws -> [EventModel] {
        let today = getTodayStartTimeStamp()
        return try await eventCollection
            .order(by: "date")
            .start(at: [today])
            .limit(to: limit)
            .getDocuments()
            .decodeArray()
    }
    
    func getAllStaves() async throws -> [StaffModel] {
        return try await staffCollection
            .getDocuments()
            .decodeArray()
    }
    
    func getAllLeaveTypes() async throws -> [LeaveTypeModel] {
        return try await leaveTypeCollection
            .getDocuments()
            .decodeArray()
    }
    
    func getAllRoles() async throws -> [RoleModel] {
        return try await roleCollection
            .getDocuments()
            .decodeArray()
    }
    
    func getAllProjects() async throws -> [ProjectModel] {
        return try await projectCollection
            .getDocuments()
            .decodeArray()
    }
    
    func getAllLeaveBalances() async throws -> [LeaveBalanceModel] {
        return try await leaveBalanceCollection
            .getDocuments()
            .decodeArray()
    }
    
    func submitLeaveRequest(with request: LeaveRequestModel) throws -> Void {
        let document = leaveRequestCollection.document()
        let updatedRequest = request.changeId(id: document.documentID)
        return try document.setData(from: updatedRequest, encoder: Firestore.Encoder())
    }
    
    func deleteLeaveRequest(with id: String) async throws -> Void {
        try await leaveRequestCollection.document(id).delete()
    }
    
    func updateLeaveRequest(with request: LeaveRequestModel) throws -> Void {
        return try leaveRequestCollection.document(request.id)
            .setData(from: request, encoder: Firestore.Encoder())
    }
    
    func getStaffBy(id: String) async throws -> StaffModel {
        return try await staffCollection.document(id)
            .getDocument(as: StaffModel.self, decoder: Firestore.Decoder())
    }
    
    func getProjectsBy(ids: [String]) async throws -> [ProjectModel] {
        return try await projectCollection
            .whereField("id", in: ids)
            .getDocuments()
            .decodeArray()
    }
    
    func getRoleBy(id: String) async throws -> RoleModel {
        return try await roleCollection
            .document(id)
            .getDocument(as: RoleModel.self, decoder: Firestore.Decoder())
    }
    
    func updateLeaveTypeBy(model: LeaveTypeModel) throws -> Void {
        return try leaveTypeCollection.document(model.id)
            .setData(from: model, encoder: Firestore.Encoder())
    }
    
    func addLeaveTypeBy(model: LeaveTypeModel) throws -> Void {
        let document = leaveTypeCollection.document()
        let updatedModel = model.changeId(id: document.documentID)
        return try document.setData(from: updatedModel, encoder: Firestore.Encoder())
    }
    
    func updateRoleBy(model: RoleModel) throws -> Void {
        return try roleCollection.document(model.id)
            .setData(from: model, encoder: Firestore.Encoder())
    }
    
    func addRoleBy(model: RoleModel) throws -> Void {
        let document = roleCollection.document()
        let updatedModel = model.changeId(id: document.documentID)
        return try document.setData(from: updatedModel, encoder: Firestore.Encoder())
    }
    
    func updateProjectBy(model: ProjectModel) throws -> Void {
        return try projectCollection.document(model.id)
            .setData(from: model, encoder: Firestore.Encoder())
    }
    
    func addProjectBy(model: ProjectModel) throws -> Void {
        let document = projectCollection.document()
        let updatedModel = model.changeId(id: document.documentID)
        return try document.setData(from: updatedModel, encoder: Firestore.Encoder())
    }
    
    func updateStaffBy(model: StaffModel) throws -> Void {
        return try staffCollection.document(model.id)
            .setData(from: model, encoder: Firestore.Encoder())
    }
    
    func addStaffBy(model: StaffModel) throws -> Void {
        return try staffCollection.document(model.id).setData(from: model, encoder: Firestore.Encoder())
    }
    
    func deleteEventBy(model: EventModel) async throws -> Void {
        return try await eventCollection.document(model.id).delete()
    }
    
    func addEventBy(model: EventModel) throws -> Void {
        let document = eventCollection.document()
        let updatedModel = model.changeId(id: document.documentID)
        return try document.setData(from: updatedModel, encoder: Firestore.Encoder())
    }
    
    func updateEventBy(model: EventModel) throws -> Void {
        return try eventCollection.document(model.id)
            .setData(from: model, encoder: Firestore.Encoder())
    }
    
    func addLeaveBalanceBy(model: LeaveBalanceModel) throws -> Void {
        let document = leaveBalanceCollection.document()
        let updatedModel = model.changeId(id: document.documentID)
        return try document.setData(from: updatedModel, encoder: Firestore.Encoder())
    }
    
    func updateLeaveBalanceBy(model: LeaveBalanceModel) throws -> Void {
        return try leaveBalanceCollection.document(model.id)
            .setData(from: model, encoder: Firestore.Encoder())
    }
    
    func getLeaveRequestsBy(staffIds: [String], startDate: Date, endDate: Date) async throws -> [LeaveRequestModel] {
        return try await leaveRequestCollection
            .order(by: "endDate")
            .whereField("endDate", isLessThanOrEqualTo: endDate)
            .whereField("endDate", isGreaterThanOrEqualTo: startDate)
            .whereField("staffId", in: staffIds)
            .getDocuments()
            .decodeArray()
    }
}


