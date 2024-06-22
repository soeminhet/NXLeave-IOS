//
//  StorageService.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 03/02/2024.
//
import Combine
import Foundation
import FirebaseStorage
import FirebaseStorageCombineSwift

class StorageService {
    
    private let reference = Storage.storage().reference()
    
    func uploadImage(data: Data) async throws -> URL {
        let image = reference.child("images/\(UUID().uuidString)")
        let _ = try await image.putDataAsync(data, metadata: nil)
        return try await image.downloadURL()
    }
}
