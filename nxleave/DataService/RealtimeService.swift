//
//  RealtimeService.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 24/01/2024.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

class RealtimeService {
    private var db: Firestore
    private var eventCollection: CollectionReference
    private var staffCollection: CollectionReference
    private var leaveRequestCollection: CollectionReference
    private var leaveBalanceCollection: CollectionReference
    private var leaveTypeCollection: CollectionReference
    private var roleCollection: CollectionReference
    
    
    init(){
        db = Firestore.firestore()
        eventCollection = db.collection("Event")
        staffCollection = db.collection("Staff")
        leaveRequestCollection = db.collection("LeaveRequest")
        leaveBalanceCollection = db.collection("LeaveBalance")
        leaveTypeCollection = db.collection("LeaveType")
        roleCollection = db.collection("Role")
    }
    
    func currentStaff(uid: String) -> AnyPublisher<StaffModel, Error> {
        return staffCollection.document(uid)
            .snapshotPublisher()
            .tryMap { snapshot in
                try snapshot.data(as: StaffModel.self)
            }
            .eraseToAnyPublisher()
    }
    
    func relatedStaves(projectIds: [String]) -> AnyPublisher<[StaffModel], Error> {
        return staffCollection
            .whereField("currentProjectIds", arrayContainsAny: projectIds)
            .snapshotPublisher()
            .map { snapshots in
                snapshots.documents.compactMap{ document -> StaffModel? in
                    return try? document.data(as: StaffModel.self, decoder: Firestore.Decoder())
                }
            }
            .eraseToAnyPublisher()
    }
    
    func relatedLeaveRequest(staffIds: [String]) -> AnyPublisher<[LeaveRequestModel], Error> {
        let today = getTodayStartTimeStamp()
        return leaveRequestCollection
            .whereField("staffId", in: staffIds)
            .order(by: "endDate", descending: false)
            .order(by: "leaveApplyDate", descending: true)
            .whereField("endDate", isGreaterThanOrEqualTo: today)
            .snapshotPublisher()
            .map { snapshots in
                snapshots.documents.compactMap{ document -> LeaveRequestModel? in
                    return try? document.data(as: LeaveRequestModel.self, decoder: Firestore.Decoder())
                }
            }
            .eraseToAnyPublisher()
    }
    
    func allLeaveRequest(by staffId: String) -> AnyPublisher<[LeaveRequestModel], Error> {
        return leaveRequestCollection
            .whereField("staffId", isEqualTo: staffId)
            .order(by: "endDate", descending: true)
            .order(by: "leaveApplyDate", descending: true)
            .snapshotPublisher()
            .map { snapshots in
                snapshots.decodeArray() as [LeaveRequestModel]
            }
            .eraseToAnyPublisher()
    }
    
    func leaveBalance(by roleId: String) -> AnyPublisher<[LeaveBalanceModel], Error> {
        return leaveBalanceCollection
            .whereField("roleId", isEqualTo: roleId)
            .snapshotPublisher()
            .map { snapshots in
                snapshots.decodeArray() as [LeaveBalanceModel]
            }
            .eraseToAnyPublisher()
    }
    
    func allRoles() -> AnyPublisher<[RoleModel], Error> {
        return roleCollection
            .snapshotPublisher()
            .map {snapshots in
                snapshots.decodeArray() as [RoleModel]
            }
            .eraseToAnyPublisher()
    }
    
    func allLeaveTypes() -> AnyPublisher<[LeaveTypeModel], Error> {
        return leaveTypeCollection
            .snapshotPublisher()
            .map {snapshots in
                snapshots.decodeArray() as [LeaveTypeModel]
            }
            .eraseToAnyPublisher()
    }
    
    func allStaves() -> AnyPublisher<[StaffModel], Error> {
        return staffCollection
            .snapshotPublisher()
            .map { snapshots in
                snapshots.decodeArray() as [StaffModel]
            }
            .eraseToAnyPublisher()
    }
    
    func allUpcomingEvents(with limit: Int) -> AnyPublisher<[EventModel], Error> {
        let today = getTodayStartTimeStamp()
        return eventCollection
            .order(by: "date")
            .start(at: [today])
            .limit(to: limit)
            .snapshotPublisher()
            .map{ snapshots in
                snapshots.decodeArray() as [EventModel]
            }
            .eraseToAnyPublisher()
    }
}
