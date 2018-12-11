//
//  GetExpireDateWorker.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 11/6/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import Foundation

class snGetExpiryDateWorker {
    func execute() -> [String] {
        let today = Date()
        let month = today.month
        let year = today.year
        
        var slots = [String]()
        let format = "%02d/%02d"
        for i in month ... 12 {
            slots.append(String(format: format, i, year))
        }
        
        for y in year + 1 ..< year + 4 {
            for m in 1 ... 12 {
                slots.append(String(format: format, m, y))
            }
        }
        return slots
    }
}
