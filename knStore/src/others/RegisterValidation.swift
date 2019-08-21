//
//  RegisterValidation.swift
//  knStore
//
//  Created by Ky Nguyen Coinhako on 12/11/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import Foundation

class RegisterCtr {
    
}

extension RegisterCtr {
    class Validation {
        var firstName: String?
        var lastName: String?
        var email: String?
        var password: String?
        func validate() -> (isValid: Bool, error: String?) {
            let emptyMessage = "%@ can't be empty"
            if firstName == nil || firstName?.isEmpty == true {
                return (false, String(format: emptyMessage, "First name")) }
            if lastName == nil || lastName?.isEmpty == true {
                return (false, String(format: emptyMessage, "Last name")) }
            if email == nil || email?.isEmpty == true {
                return (false, String(format: emptyMessage, "Email")) }
            if password == nil || password?.isEmpty == true  {
                return (false, String(format: emptyMessage, "Password")) }

            if email?.isValidEmail() == false {
                return (false, "Invalid email") }

            let passwordCheck = knPasswordValidation()
            if passwordCheck.checkCharCount(password!) == false {
                return (false, "Password has at least 8 characters") }
            if passwordCheck.checkUpperCase(password!) == false {
                return (false, "Password has at least 1 Uppercase character") }
            if passwordCheck.checkNumberDigit(password!) == false {
                return (false, "Password has at least 1 digit") }

            return (true, nil)
        }
    }
}
