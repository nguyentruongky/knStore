//
//  Auth.swift
//  BondProject
//
//  Created by Ky Nguyen on 8/16/19.
//  Copyright © 2019 Jeffrey Zavattero. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Authentication {
    static let myId = Auth.auth().currentUser?.uid
}
