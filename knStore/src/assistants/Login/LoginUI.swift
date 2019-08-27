//
//  LoginUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension LoginController {
    class UI {
        let coverImgView = UIMaker.makeImageView(image: UIImage(named: "login_cover"), contentMode: .scaleAspectFill)
        let emailTextField = UIMaker.makeTextField(placeholder: "Email",
                                                   icon: UIImage(named: "email"))
        let passwordTextField = UIMaker.makeTextField(placeholder: "Password",
                                                      icon: UIImage(named: "password"))
        var revealButton: UIButton!
        let forgotButton = UIMaker.makeButton(title: "Forgot password?",
                                              titleColor: UIColor(r: 163, g: 169, b: 175),
                                              font: UIFont.main(size: 13))
        let closeButton = UIMaker.makeButton(image: UIImage(named: "close"))
        let loginButton = UIMaker.makeMainButton(title: "SIGN IN")
        lazy var registerButton = makeRegisterButton()
        func makeRegisterButton() -> UIButton {
            let button = UIMaker.makeButton(title: "Don't have an account? Join Us",
                                            titleColor: UIColor(r: 163, g: 169, b: 175),
                                            font: UIFont.main(size: 13))
            button.titleLabel?.formatText(boldStrings: ["Join Us"],
                                          boldFont: UIFont.main(size: 13),
                                          boldColor: UIColor(value: 29))
            return button
        }

        func setupView() -> [knTableCell] {
            emailTextField.keyboardType = .emailAddress
            emailTextField.autocapitalizationType = .none
            passwordTextField.isSecureTextEntry = true
            revealButton = passwordTextField.setView(.right,
                                                     image: UIImage(named: "show_pass_inactive"))
            revealButton.addTarget(self, action: #selector(showPass))

            let contentCell = knTableCell()
            contentCell.addSubviews(views: emailTextField, passwordTextField, forgotButton, loginButton, registerButton)
            contentCell.addConstraints(withFormat: "V:|-24-[v0]-16-[v1]-24-[v2]-32-[v3]-32-[v4]-8-|",
                                       views: emailTextField, passwordTextField, forgotButton, loginButton, registerButton)
            emailTextField.horizontal(toView: contentCell, space: 24)
            emailTextField.height(50)

            passwordTextField.horizontal(toView: emailTextField)
            passwordTextField.height(50)

            forgotButton.right(toView: emailTextField)
            loginButton.horizontal(toView: emailTextField)
            registerButton.centerX(toView: emailTextField)

            return [contentCell]
        }

        @objc func showPass() {
            passwordTextField.toggleSecure()
            let show = passwordTextField.isSecureTextEntry
            let iconName = show ? "show_pass_inactive" : "show_pass_active"
            revealButton.setImage(UIImage(named: iconName), for: .normal)
        }

        func makeHeader() -> UIView {
            let headerView = UIMaker.makeView()
            headerView.addSubviews(views: coverImgView)
            coverImgView.fill(toView: headerView)

            closeButton.square(edge: 44)
            headerView.addSubviews(views: closeButton)
            closeButton.topLeft(toView: headerView, top: 16, left: 8)

            headerView.backgroundColor = .blue
            return headerView
        }

    }
}

