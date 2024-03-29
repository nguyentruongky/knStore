//
//  RegisterUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/9/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension RegisterController {
    class UI: NSObject {
        let firstNameTextField = UIMaker.makeTextField(placeholder: "First Name",
                                                       icon: UIImage(named: "profile"))
        let lastNameTextField = UIMaker.makeTextField(placeholder: "Last Name",
                                                      icon: UIImage(named: "profile"))
        let emailTextField = UIMaker.makeTextField(placeholder: "Email",
                                                   icon: UIImage(named: "email"))
        let passwordTextField = UIMaker.makeTextField(placeholder: "Password",
                                                      icon: UIImage(named: "password"))
        let registerButton = UIMaker.makeMainButton(title: "CREATE ACCOUNT ")
        lazy var signinButton = makeSigninButton()
        var revealButton: UIButton!
        func makeSigninButton() -> UIButton {
            let strongText = "Sign In"
            let button = UIMaker.makeButton(title: "Already have an account? \(strongText)",
                titleColor: UIColor(r: 163, g: 169, b: 175),
                font: UIFont.main(size: 13))
            button.titleLabel?.formatText(boldStrings: [strongText],
                                          boldFont: UIFont.main(size: 13),
                                          boldColor: UIColor(value: 19))
            button.titleLabel?.underline(string: strongText)
            return button
        }
        lazy var termLabel: KNTermLabel = {
            let label = KNTermLabel()
            let font = UIFont.main(size: 11)
            let color = UIColor(r: 163, g: 169, b: 175)
            let strongText = "Terms and Conditions."
            label.formatText(fullText: "By signing up you agree with our \(strongText)",
                boldTexts: [strongText],
                boldFont: font, boldColor: color,
                font: font, color: color,
                alignment: .center, lineSpacing: 7,
                actions: [{ [weak self] in self?.viewTerm()} ])
            label.underline(string: strongText)
            return label
        }()

        @objc func viewTerm() {

        }

        func makeCell(tf: UITextField) -> KNTableCell {
            let cell = KNTableCell()
            cell.addSubviews(views: tf)
            tf.fill(toView: cell, space: UIEdgeInsets(left: space, bottom: 16, right: space))
            tf.height(50)
            return cell
        }

        func setupView() -> [KNTableCell] {
            emailTextField.keyboardType = .emailAddress
            emailTextField.autocapitalizationType = .none
            emailTextField.returnKeyType = .next

            passwordTextField.isSecureTextEntry = true
            passwordTextField.returnKeyType = .next

            firstNameTextField.autocapitalizationType = .words
            firstNameTextField.returnKeyType = .next

            lastNameTextField.autocapitalizationType = .words
            lastNameTextField.returnKeyType = .next

            revealButton = passwordTextField.setView(.right,
                                                     image: UIImage(named: "show_pass_inactive") ?? UIImage())
            revealButton.addTarget(self, action: #selector(showPassword))

            return [
                makeCell(tf: firstNameTextField),
                makeCell(tf: lastNameTextField),
                makeCell(tf: emailTextField),
                makeCell(tf: passwordTextField)
            ]
        }

        @objc func showPassword() {
            passwordTextField.toggleSecure()
            let image = passwordTextField.isSecureTextEntry ? UIImage(named: "show_pass_active") : UIImage(named: "show_pass_inactive")
            revealButton.setImage(image, for: .normal)
        }

        func makeFooter() -> UIView {
            let view = UIMaker.makeView()
            view.addSubviews(views: registerButton, signinButton, termLabel)
            view.addConstraints(withFormat: "V:|-24-[v0]-25-[v1]-16-[v2]",
                                views: registerButton, signinButton, termLabel)
            registerButton.horizontal(toView: view, space: space)
            signinButton.centerX(toView: view)
            signinButton.height(24)
            termLabel.horizontal(toView: view)
            return view
        }
    }
}
