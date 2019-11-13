//
//  FavoriteManager.swift
//  BondProject
//
//  Created by Jeffrey Zavattero on 8/15/19.
//  Copyright © 2019 Jeffrey Zavattero. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FavoriteManager: NSObject {
    weak var navigationItem: UINavigationItem?
    private var bondId: String?
    func setBondId(_ bondId: String) {
        self.bondId = bondId
        checkFavorite(bondId: bondId) { [weak self] (_isFavorite) in
            self?.isFavorite = _isFavorite
            if _isFavorite {
                self?.addUnfavoriteButton()
            } else {
                self?.addFavoriteButton()
            }
        }
    }
    
    private var isFavorite = false
    init(navigationItem: UINavigationItem?) {
        super.init()
        self.navigationItem = navigationItem
        addFavoriteButton()
    }
    
    func addFavoriteButton() {
        navigationItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "not-favorite")?.changeColor(), style: .plain, target: self, action: #selector(addToFavorite))
        navigationItem?.rightBarButtonItem?.tintColor = .white
    }
    
    func addUnfavoriteButton() {
        navigationItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")?.changeColor(), style: .plain, target: self, action:  #selector(removeFromFavorite))
        navigationItem?.rightBarButtonItem?.tintColor = .white
    }
    
    
    @objc func addToFavorite() {
        isFavorite = true
        addUnfavoriteButton()
        if let bondId = bondId {
            guard let myId = Authentication.myId else { return }
            DatabaseService.saveData(bucket: Bucket.favorite, document: myId, data: [bondId: true])
        }
    }
    
    @objc func removeFromFavorite() {
        isFavorite = false
        addFavoriteButton()
        if let bondId = bondId {
            guard let myId = Authentication.myId else { return }
            DatabaseService.removeData(bucket: Bucket.favorite, document: myId, fieldName: bondId)
        }
    }
    
}

// MARK: DATA
extension FavoriteManager {
    
    func checkFavorite(bondId: String, completion: @escaping(Bool) -> Void) {
        DatabaseService.query(bucket: Bucket.favorite, filterKey: bondId, filterValue: true) { (_rawData) in
            guard let rawData = _rawData.first else {
                completion(false)
                return
            }
            let bonds = Array(rawData.keys)
            completion(bonds.contains(bondId))
        }
    }
    
    static func getFavoriteBonds(completion: @escaping([Bond]) -> Void) {
        DatabaseService.loadFavorite(completion: completion)
    }
}
