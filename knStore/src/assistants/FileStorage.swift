//
//  FileStorage.swift
//  KNStore
//
//  Created by Ky Nguyen on 8/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import Foundation
import FirebaseStorage

struct FileStorage {
    func upload(image: UIImage, to node: String, completion: ((_ url: String?) -> Void)?) {
        guard let image = image.pngData() else {
            completion?(nil)
            return
        }
        let ref = Storage.storage()
            .reference()
            .child(node)
            .child(UUID().uuidString + ".png")
            
        ref.putData(image, metadata: nil) { (storage, error) in
            if error != nil {
                completion?(nil)
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion?(nil)
                    return
                }
                completion?(downloadURL.absoluteString)
            }
        }
    }
}
