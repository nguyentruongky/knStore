//
//  UpdatePassword.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 11/17/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import Foundation
struct snChangePassWorker: knWorker {
    private let api = "/users/me/"
    var oldPass: String
    var newPass: String
    var confirmPass: String
    
    var success: ((String) -> Void)?
    var fail: ((knError) -> Void)?
    init(oldPass: String, newPass: String, confirmPass: String,
         success: ((String) -> Void)?, fail: ((knError) -> Void)?) {
        self.oldPass = oldPass
        self.newPass = newPass
        self.confirmPass = confirmPass
        self.success = success
        self.fail = fail
    }
    
    func execute() {
        let params = [
            "current_password": oldPass,
            "new_password": newPass,
            "confirm_password": confirmPass
        ]
        ServiceConnector.patch(api, params: params, success: successResponse, fail: failResponse)
    }
    
    private func successResponse(returnData: AnyObject) {
        print(returnData)
        if let errMessage = returnData["detail"] as? String {
            failResponse((knError(code: "wrong_password", message: errMessage, data: nil)))
            return
        }
        success?("Password changed")
    }
    
    private func failResponse(_ err: knError) {
        fail?(err)
    }
}
