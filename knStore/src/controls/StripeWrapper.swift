//
//  StripeWrapper.swift
//  Appety
//
//  Created by Ky Nguyen on 1/17/19.
//  Copyright © 2019 Appety B.V. All rights reserved.
//

import Foundation
import Stripe


struct StripeWrapper {
    let userId: String
    let authKey: String
    let secretKey: String
    let publicKey: String

    init(userId: String, authKey: String, secretKey: String, publicKey: String) {
        self.userId = userId
        self.authKey = authKey
        self.secretKey = secretKey
        self.publicKey = publicKey
        STPPaymentConfiguration.shared().publishableKey = publicKey
    }

    func createCard(card: Card,
                    successAction: @escaping (_ cardToken: String) -> Void,
                    failAction: ((_ error: knError) -> Void)?) {
        let cardParams = STPCardParams()
        cardParams.number = card.number.remove("-")
        cardParams.expMonth = UInt(card.expMonth) ?? 1
        cardParams.expYear = UInt(card.expYear) ?? 2020
        cardParams.cvc = card.cvc
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, err) in
            if let err = err {
                let error = knError(code: "create_card_fail",
                                    message: err.localizedDescription)
                failAction?(error)
                return
            }

            if let cardToken = token?.tokenId {
                successAction(cardToken)
            }
        }
    }

    func charge(amountInSmallestUnit amount: Double,
                currency: String, cardToken: String,
                transactionId: String,
                successAction: @escaping (_ chargeId: String) -> Void,
                failAction: ((_ error: knError) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let chargeId = returnData["id"] as? String else {
                var message = returnData.value(forKeyPath: "error.message") as? String
                message = message ?? "Can't charge at this time"
                let code = returnData.value(forKeyPath: "error.code") as? String ?? "charge_fail"
                failAction?(knError(code: code, message: message!))
                return
            }

            successAction(chargeId)
        }

        let api = "https://api.stripe.com/v1/charges"
        let header = [
            "Authorization": appSetting.stripeKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "amount": amount,
            "currency": currency,
            "source": cardToken,
            "description": "transaction_id \(transactionId)",
            ] as [String : Any]

        ServiceConnector.post(api, params: params, headers: header,
                              success: successResponse, fail: { err in failAction?(err) })
    }

    func createUser(email: String,
                    successAction: ((_ userId: String) -> Void)?,
                    failAction: ((knError) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let userId = returnData["id"] as? String else {
                var message = returnData.value(forKeyPath: "error.message") as? String
                message = message ?? "Unable to create user for \(email)"
                let code = returnData.value(forKeyPath: "error.code") as? String ?? "charge_fail"
                failAction?(knError(code: code, message: message!))
                return
            }

            successAction?(userId)
        }

        let api = "https://api.stripe.com/v1/customers"
        let header = [
            "Authorization": appSetting.stripeKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        ServiceConnector.post(api, headers: header, success: successResponse, fail: failAction)
    }
}


struct Card {
    var number: String
    var userName: String
    var expiration: String
    var cvc: String
    var expMonth = ""
    var expYear = ""

    init(number: String, userName: String, expiration: String, cvc: String) {
        self.number = number
        self.userName = userName
        self.expiration = expiration
        self.cvc = cvc

        let expiry = expiration.splitString("/")
        expMonth = expiry.first.or("")
        expYear = expiry.last.or("")
    }
}
