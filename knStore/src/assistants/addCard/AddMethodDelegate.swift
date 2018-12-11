//
//  AddMethodDelegate.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 11/6/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

class snCardNumberHandler: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if let text = textField.text, text.count > 0 {
            let latestChar = text.substring(from: 1)
            if text.count - newText.count == 1 &&
                latestChar == "-" {
                newText = newText.substring(to: newText.count - 1)
            }
        }
        
        let latestChar = newText.substring(from: 1)
        let removeDash = newText.remove("-")
        if removeDash.count % 4 == 0 && latestChar != "-" {
            if removeDash.count != 16 && removeDash.count != 0 {
                newText += "-"
            }
        }
        textField.text = newText
        return false
    }
}

class snNameHandler: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        textField.text = newText
        return false
    }
}

class snCVVHandler: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        textField.text = newText
        return false
    }
}
