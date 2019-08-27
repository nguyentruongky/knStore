//
//  ChangePass.UI.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 11/8/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

extension snChangePassCtr {
    class UI: NSObject {
        let padding: CGFloat = 32
        var updatePass: (() -> Void)?

        lazy var oldPassTextField = makePassword(placeholder: "Old Password*", tag: 1000)
        lazy var newPassTextField = makePassword(placeholder: "New Password*", tag: 1001)
        lazy var confirmPassTextField = makePassword(placeholder: "Confirm New Password*", tag: 1002)
        
        let saveButton = UIMaker.makeMainButton(title: "SAVE MY NEW PASSWORD")
        
        func makePassword(placeholder: String, tag: Int) -> UITextField {
            let tf = UIMaker.makeTextField(placeholder: placeholder,
                                           icon: UIImage(named: "password"))
            tf.isSecureTextEntry = true
            tf.returnKeyType = .next
            let button = tf.setView(.right, image: UIImage(named: "show_pass_inactive") ?? UIImage())
            button.tag = tag
            button.addTarget(self, action: #selector(showPassword))
            return tf
        }
        
        @objc func showPassword(button: UIButton) {
            let tag = button.tag - 1000
            let textfields = [
                oldPassTextField,
                newPassTextField,
                confirmPassTextField
            ]
            textfields[tag].toggleSecure()
            let image = textfields[tag].isSecureTextEntry ? UIImage(named: "show_pass_inactive") : UIImage(named: "show_pass_active")
            button.setImage(image, for: .normal)
        }
        
        func setupView() -> [knTableCell] {
            oldPassTextField.returnKeyType = .next
            oldPassTextField.delegate = self
            
            newPassTextField.returnKeyType = .next
            newPassTextField.delegate = self
            
            confirmPassTextField.returnKeyType = .done
            confirmPassTextField.delegate = self
            
            let note = "Your new password must be at least 8 characters, 1 uppercase letter and 1 number."
            let label = UIMaker.makeLabel(text: note, font: UIFont.main(size: 11),
                                          color: UIColor(r: 163, g: 169, b: 175), numberOfLines: 0)
            label.setLineSpacing()
            let noteCell = knTableCell()
            noteCell.addSubviews(views: label)
            label.fill(toView: noteCell, space: UIEdgeInsets(left: padding, bottom: 32, right: padding))
            
            return [
                makeCell(tf: oldPassTextField),
                makeCell(tf: newPassTextField),
                makeCell(tf: confirmPassTextField),
                noteCell
            ]
        }
        
        func makeCell(tf: UITextField) -> knTableCell {
            let cell = knTableCell()
            cell.addSubviews(views: tf)
            tf.fill(toView: cell, space: UIEdgeInsets(left: padding, bottom: 16, right: padding))
            tf.height(50)
            return cell
        }
    }
}

extension snChangePassCtr.UI: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPassTextField {
            newPassTextField.becomeFirstResponder()
        } else if textField == newPassTextField {
            confirmPassTextField.becomeFirstResponder()
        } else {
            updatePass?()
        }
        return true
    }
}
