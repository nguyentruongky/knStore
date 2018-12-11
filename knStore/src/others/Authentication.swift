//
//  Authentication.swift
//  Coinhako
//
//  Created by Ky Nguyen on 9/7/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import UIKit
import LocalAuthentication

class Authentication {
    var didAuthSuccess: (() -> Void)?
    var didAuthFail: ((_ message: String) -> Void)?
    var holderController: UIViewController?
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authenticateWithTouchId(context: context)
        }
        else {
            authenticateWithPIN()
        }
    }
    
    static var doesTouchIdExist: Bool {
        let context = LAContext()
        let doesExist = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return doesExist
    }
    
    func authenticateWithTouchId(context: LAContext) {
        var reason = "touch_id_request".i18n
        if hasNotch() {
            reason = reason.replacingOccurrences(of: "Touch ID", with: "Face ID")
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: reason,
                               reply: { [weak self] (isSuccess, err) in
                                self?.didAuthenticateWithTouchId(isSuccess: isSuccess, err: err) })
    }
    
    
    func didAuthenticateWithTouchId(isSuccess: Bool, err: Error?) {
        
        if isSuccess {
            DispatchQueue.main.async { [weak self] in
                self?.didAuthSuccess?()
            }
            return
        }
        
        var message = ""
        switch(err!) {
        case LAError.authenticationFailed:
            message = "touch_id_fail".i18n
            if hasNotch() {
                message = message.replacingOccurrences(of: "Touch ID", with: "Face ID")
            }
            
        case LAError.systemCancel, LAError.userCancel, LAError.passcodeNotSet, LAError.biometryNotEnrolled, LAError.biometryNotAvailable, LAError.appCancel:
            return
            
        case LAError.biometryLockout:
            message = "touch_id_lock".i18n
            if hasNotch() {
                message = message.replacingOccurrences(of: "Touch ID", with: "Face ID")
            }
            
        case LAError.invalidContext:
            message = "touch_id_invalid_context".i18n
            if hasNotch() {
                message = message.replacingOccurrences(of: "Touch ID", with: "Face ID")
            }
            
        default:
            message = "touch_id_not_config".i18n
            if hasNotch() {
                message = message.replacingOccurrences(of: "Touch ID", with: "Face ID")
            }
            break
        }
        
        didAuthFail?(message)
    }
    
    func authenticateWithPIN() {
        let controller = UIViewController()
        holderController?.push(controller)
    }
}
