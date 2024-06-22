//
//  QuerySnapshotExt.swift
//  nxleave
//
//  Created by Soe Min Htet M1 MackBook Pro on 25/01/2024.
//

import Foundation
import FirebaseFirestore

extension QuerySnapshot {
    func decodeArray<T: Decodable>() -> [T] {
        documents.compactMap{ document -> T? in
            return try? document.data(as: T.self, decoder: Firestore.Decoder())
        }
    }
}
