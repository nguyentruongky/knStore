////
////  StripeWrapper.swift
////  OXTRUX
////
////  Created by Greg Dion on 3/11/19.
////  Copyright © 2019 OXTRUX LLX. All rights reserved.
////
//
import Foundation
import Stripe
import Alamofire

struct StripeWrapper {
    private let BASEURL = "https://api.stripe.com/v1"
    var userId: String?
    private let authKey: String
    private let secretKey: String
    private let publicKey: String
    private let applePayID: String? = "merchant.com.oxtrux.oxtrux"

    init(userId: String? = nil, secretKey: String, publicKey: String) {
        self.userId = userId
        authKey = "Bearer " + secretKey
        self.secretKey = secretKey
        self.publicKey = publicKey
        config()
    }

    func createUser(name: String, phone: String, email: String,
                    successAction: ((_ userId: String) -> Void)?,
                    failAction: ((Error) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let userId = returnData["id"] as? String else {
                var message = returnData.value(forKeyPath: "error.message") as? String
                message = message ?? "Unable to create user for \(email)"
                failAction?(NSError(domain: message!, code: -1, userInfo: nil))
                return
            }
            successAction?(userId)
        }

        let api = "/customers"
        let description = "Create account for user \(name), phone: \(phone), email: \(email)"
        let params = [
            "description": description,
            "email": email
        ]

        execute(api: api,
                params: params,
                method: .post,
                successResponse: successResponse,
                failResponse: failAction)
    }

    func createCard(card: Card,
                    successAction: @escaping (_ cardToken: String) -> Void,
                    failAction: ((_ error: Error) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let cardId = returnData["id"] as? String else {
                failAction?(NSError(domain: "no_card_token", code: -1))
                return
            }
            successAction(cardId)
        }

        let cardParams = STPCardParams(card: card)
        STPAPIClient.shared()
            .createToken(withCard: cardParams) { (token, err) in
                guard let token = token,
                    let userId = self.userId else { return }
                let api = "/customers/\(userId)/sources"

                self.execute(api: api,
                             params: ["source": token.tokenId],
                             method: .post,
                             successResponse: successResponse,
                             failResponse: failAction)
        }
    }

    func getPaymentMethods(successAction: @escaping (_ cards: [Card]) -> Void,
                           failAction: ((_ error: Error) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let rawData = returnData["data"] as? [AnyObject] else {
                successAction([])
                return
            }

            let cards = rawData.map({ return Card(raw: $0) })
            successAction(cards)
        }

        guard let userId = userId else { return }
        let api = "/customers/\(userId)/sources?object=card"
        execute(api: api,
                method: .get,
                successResponse: successResponse,
                failResponse: failAction)
    }

    func removeCard(cardId: String,
                    successAction: (() -> Void)? = nil,
                    failAction: ((_ error: Error) -> Void)? = nil) {
        guard let userId = userId else { return }
        let api = "/customers/\(userId)/sources/\(cardId)"
        execute(api: api,
                method: .delete,
                successResponse: { _ in successAction?() },
                failResponse: failAction)
    }

    func updateCard(cardId: String,
                    expMonth: Int? = nil,
                    expYear: Int? = nil,
                    successAction: (() -> Void)? = nil,
                    failAction: ((_ error: Error) -> Void)? = nil) {
        guard let userId = userId else { return }
        var params = [String: Any]()
        if let data = expMonth {
            params["exp_month"] = data
        }

        if let data = expYear {
            params["exp_year"] = data
        }

        guard params.isEmpty == false else {
            successAction?()
            return
        }

        let api = "/customers/\(userId)/sources/\(cardId)"
        execute(api: api,
                params: params,
                method: .post,
                successResponse: { _ in successAction?() },
                failResponse: failAction)
    }

    func charge(amountInSmallestUnit amount: Double,
                currency: String, cardToken: String,
                transactionId: String,
                successAction: @escaping (_ chargeId: String) -> Void,
                failAction: ((_ error: Error) -> Void)?) {
        func successResponse(returnData: AnyObject) {
            guard let chargeId = returnData["id"] as? String else {
                var message = returnData.value(forKeyPath: "error.message") as? String
                message = message ?? "Can't charge at this time"
                let err = NSError(domain: message!, code: -1, userInfo: nil)
                failAction?(err)
                return
            }

            successAction(chargeId)
        }

        let api = "https://api.stripe.com/v1/charges"
        let headers = [
            "Authorization": authKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "amount": amount,
            "currency": currency,
            "source": cardToken,
            "description": "transaction_id \(transactionId)",
            ] as [String : Any]

        Alamofire.request(api,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                if let error = response.result.error {
                    failAction?(error)
                    return
                }

                let returnData = response.result.value as AnyObject
                successResponse(returnData: returnData)
        }
    }
}

extension StripeWrapper {
    private func execute(api: String,
                         params: [String: Any] = [:],
                         method: HTTPMethod,
                         successResponse: ((AnyObject) -> Void)? = nil,
                         failResponse: ((Error) -> Void)? = nil) {
        let headers = [
            "Authorization": authKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let encoding: URLEncoding = {
            switch method {
            case .get, .delete:
                return .queryString
            default:
                return .httpBody
            }
        }()
        guard let url = URL(string: BASEURL + api) else { return }
        Alamofire
            .request(url,
                     method: method,
                     parameters: params,
                     encoding: encoding,
                     headers: headers)
            .responseJSON { (response) in
                if let error = response.result.error {
                    failResponse?(error)
                    return
                }

                let returnData = response.result.value as AnyObject
                successResponse?(returnData)
        }
    }

    private func config() {
        STPPaymentConfiguration.shared().publishableKey = publicKey
        if let applePayId = applePayID {
            STPPaymentConfiguration.shared().appleMerchantIdentifier = applePayId
        }
    }
}



extension STPCardParams {
    convenience init(card: Card) {
        self.init()
        number = card.number.replacingOccurrences(of: "-", with: "")
        expMonth = UInt(card.expMonth) ?? 1
        expYear = UInt(card.expYear) ?? 2020
        cvc = card.cvc
    }
}


struct Card {
    var id: String?
    var number: String
    var userName: String?
    var expiration: String
    var cvc: String?
    var expMonth = ""
    var expYear = ""
    var type: String?

    init(number: String, userName: String, expiration: String, cvc: String) {
        self.number = number
        self.userName = userName
        self.expiration = expiration
        self.cvc = cvc

        let expiry = expiration.components(separatedBy: "/")
        expMonth = expiry.first ?? ""
        expYear = expiry.last ?? ""
    }

    init(raw: AnyObject) {
        number = raw["last4"] as? String ?? ""
        userName = ""
        expMonth = raw["exp_month"] as? String ?? "12"
        expYear = raw["exp_year"] as? String ?? "2020"
        cvc = ""

        expiration = "\(expMonth)\(expYear)"
        id = raw["id"] as? String
        type = raw["brand"] as? String
    }
}

