//
//  Login.swift
//  CountTheVote
//
//  Created by Ky Nguyen on 1/17/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class LoginCtr: knStaticListController {
    let ui = UI()
    override func setupView() {
        view.addFill(tableView)
        datasource = ui.setupView()
    }
}

extension LoginCtr {
    class UI {
        let padding: CGFloat = 24
        lazy var emailTextField = makeTextField(placeholder: "Email")
        lazy var passwordTextField = makeTextField(placeholder: "Password")
        let loginButton = UIMaker.makeMainButton(title: "LOGIN")

        func setupView() -> [knTableCell] {
            let forgotButton = UIMaker.makeButton(title: "Forgot Password?",
                                                  titleColor: UIColor.darkGray,
                                                  font: UIFont.main(.bold, size: 13))
            forgotButton.contentHorizontalAlignment = .right

            let inset = UIEdgeInsets(left: padding, bottom: padding, right: padding)
            let emailCell = UIMaker.wrapToCell(emailTextField, space: inset)
            let passwordCell = UIMaker.wrapToCell(passwordTextField, space: inset)
            let forgotCell = UIMaker.wrapToCell(forgotButton,
                                                space: inset)

            let loginButtonCell = UIMaker.wrapToCell(loginButton, space: inset)
            return [emailCell, passwordCell, forgotCell, loginButtonCell]
        }

        func makeTextField(placeholder: String) -> UITextField {
            let tf = UIMaker.makeTextField(placeholder: placeholder,
                                           font: UIFont.main(),
                                           color: UIColor.black)
            tf.setView(.left, space: 16)
            tf.height(48)
            tf.setCorner(radius: 5)
            tf.setBorder(width: 1, color: UIColor.lightGray)
            return tf
        }
    }
}
