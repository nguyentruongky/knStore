//
//  RegisterDeviceTokenWorker.swift
//  Marco
//
//  Created by Ky Nguyen on 6/20/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import Foundation

struct KNRegisterDeviceTokenWorker {

    var api: String
    var params: [String: Any]

    func execute() {

        func handleSuccess(returnData: AnyObject) {
            print(returnData)
        }

        func handleError(_ error: KNError) {
        }

//        ServiceConnector.post(api, params: params, success: handleSuccess, fail: handleError)
    }

}
