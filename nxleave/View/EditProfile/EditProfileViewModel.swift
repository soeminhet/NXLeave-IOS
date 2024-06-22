//
//  EditProfileViewModel.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 03/02/2024.
//

import Foundation
import SwiftUI

@MainActor class EditProfileViewModel: ObservableObject {
    
    @AppStorage("uid") var uid: String = ""
    
    private let storageService = StorageService()
    private let firestoreService = FirestoreService()
    @Published var staff: StaffModel? = nil
    @Published var loading: Bool = false
    
    func fetchStaff() async {
        loading = true
        do {
            staff = try await firestoreService.getStaffBy(id: uid)
        } catch(let error){
            print(error.localizedDescription)
        }
        loading = false
    }
    
    
    func updateStaff(
        name: String,
        phonenumber: String,
        data: Data?
    ) async -> Bool {
        guard let staff = staff else { return false }
        loading = true
        var photoURL: String? = nil
        do {
            if let data = data {
                let downloadURL = try await storageService.uploadImage(data: data)
                photoURL = downloadURL.absoluteString
            }
            print(name)
            print(phonenumber)
            let updatedStaff = staff.changeInfo(
                name: name,
                phone: phonenumber,
                photo: photoURL ?? staff.photo
            )
            print(updatedStaff)
            try firestoreService.updateStaffBy(model: updatedStaff)
            loading = false
            return true
        } catch(let error) {
            loading = false
            print(error.localizedDescription)
            return false
        }
    }
}
