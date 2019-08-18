//
//  Database.swift
//  BondProject
//
//  Created by Ky Nguyen on 8/16/19.
//  Copyright © 2019 Jeffrey Zavattero. All rights reserved.
//

import Foundation
import FirebaseFirestore
 
struct Bucket {
    static let favorite = "favorite_bonds"
    static let bonds = "bonds"
    static let transactions = "transactions"
    static let users = "users"
}

struct Database {
    static func loadBonds(completion: @escaping([Bond]) -> Void) {
        loadData(bucket: Bucket.bonds, document: "", completion: { rawData in
            let bonds = rawData.compactMap({ return Bond(data: $0)
            })
            completion(bonds)
        })
    }
    
    static func loadFavorite(completion: @escaping([Bond]) -> Void) {
        guard let myId = Authentication.myId else {
            completion([])
            return
        }
        Firestore.firestore()
            .collection("favorite_bonds")
            .document(myId)
            .getDocument { (snapshot, error) in
                guard let data = snapshot?.data() else {
                    completion([])
                    return
                }
                let bondIds = Array(data.keys)
                AllLoader().load { (bonds) in
                    let favBonds = bonds.filter({ bondIds.contains($0.id) })
                    completion(favBonds)
                }
        }
    }
    
    static func loadData(bucket: String, document: String, completion: @escaping([[String: Any]]) -> Void) {
        if document.isEmpty {
            Firestore.firestore().collection(bucket).getDocuments { (snapshot, error) in
                guard let rawData = snapshot?.documents.map({ return $0.data() }) else {
                    completion([])
                    return
                }
                completion(rawData)
            }
        } else {
            Firestore.firestore().collection(bucket)
                .document(document)
                .getDocument { (snapshot, _) in
                    snapshot?.data()
                    let data = snapshot?.data() ?? [:]
                    completion([data])
            }
        }
    }
    
    static func saveData(bucket: String, document: String = "", data: [String: Any], merge: Bool = true, completion: (() -> Void)? = nil) {
        if document.isEmpty {
            Firestore.firestore()
                .collection(bucket)
                .addDocument(data: data) { (error) in
                    print("save data to \(bucket) has error \(String(String(describing: error)))")
                    completion?()
            }
        } else {
            Firestore.firestore()
                .collection(bucket)
                .document(document)
                .setData(data, merge: merge)
        }
    }
    
    static func removeData(bucket: String, document: String, fieldName: String) {
        Firestore.firestore().collection(bucket)
            .document(document)
            .updateData([fieldName: FieldValue.delete()])
    }
    
    static func query(bucket: String, filterKey: String, filterValue: Any, completion: @escaping([[String: Any]]) -> Void) {
        Firestore.firestore().collection(bucket)
            .whereField(filterKey, isEqualTo: filterValue)
            .getDocuments { (snapshot, error) in
                guard let docs = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let rawData = docs.compactMap({ return $0.data() })
                completion(rawData)
        }
    }
}
