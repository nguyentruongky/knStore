//
//  AddCard.UI.swift
//  invo-ios
//
//  Created by Ky Nguyen Coinhako on 11/28/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

extension INAddCardCtr {
    class UI {
        let cardNumberTextField = UIMaker.makeTextField(placeholder: "Card Number*")
        let nameTextField = UIMaker.makeTextField(placeholder: "Name on Card*")
        let expiryDateTextField = UIMaker.makeTextField(placeholder: "Expiry Date*")
        let cvvTextField = UIMaker.makeTextField(placeholder: "CVV*")
        var saveSwitch = UISwitch()
        let saveButton = UIMaker.makeMainButton(title: "SAVE AND CONTINUE")
        
        let datePicker = knPickerView.make(texts: [])
        func setupView() -> [knTableCell] {
            datePicker.changeDateMode(mode: .date)
            let detailView = makeDetailView()
            let saveView = makeSaveView()
            
            let spaceCell = knTableCell()
            spaceCell.backgroundColor = UIColor(r: 243, g: 245, b: 248)
            spaceCell.height(44)
            
            let cell = knTableCell()
            cell.addSubviews(views: detailView, saveView)
            cell.addConstraints(withFormat: "V:|-24-[v0][v1]|", views: detailView, saveView)
            detailView.horizontal(toView: cell)
            saveView.horizontal(toView: cell)
            return [spaceCell, cell]
        }
        
        private func makeSaveView() -> UIView {
            let line = UIMaker.makeHorizontalLine(color: UIColor(r: 230, g: 232, b: 234),
                                        height: 1)
            let bottomLine = UIMaker.makeHorizontalLine(color: UIColor(r: 230, g: 232, b: 234),
                                              height: 1)
            let label = UIMaker.makeLabel(text: "Save my card details?",
                                          font: UIFont.main(.medium, size: 14),
                                          color: UIColor(value: 25))
            saveSwitch.translatesAutoresizingMaskIntoConstraints = false
            saveSwitch.onTintColor = UIColor(r: 105, g: 101, b: 203)
            let view = UIMaker.makeView(background: .white)
            view.addSubviews(views: line, label, saveSwitch, bottomLine)
            view.height(50)
            line.horizontal(toView: view)
            line.top(toView: view)
            
            saveSwitch.right(toView: view, space: -16)
            saveSwitch.centerY(toView: view)
            
            label.left(toView: view, space: 16)
            label.centerY(toView: view)
            
            bottomLine.horizontal(toView: view)
            bottomLine.bottom(toView: view)
            return view
        }
        
        private func makeDetailView() -> UIView {
            cardNumberTextField.keyboardType = .numberPad
            nameTextField.autocapitalizationType = .words
            cvvTextField.keyboardType = .numberPad
            expiryDateTextField.setView(.right,
                                        image: UIImage(named: "down_arrow") ?? UIImage())
            
            let cardLabel = UIMaker.makeLabel(text: "YOUR CREDIT CARD DETAILS",
                                              font: UIFont.main(.medium, size: 12),
                                              color: UIColor(value: 25))
            
            let view = UIMaker.makeView(background: .white)
            view.addSubviews(views: cardLabel, cardNumberTextField, nameTextField, expiryDateTextField, cvvTextField)
            view.addConstraints(withFormat: "V:|[v0]-16-[v1]-16-[v2]-16-[v3]-24-|",
                                views: cardLabel, cardNumberTextField, nameTextField, expiryDateTextField)
            cardLabel.horizontal(toView: view, space: 16)
            cardNumberTextField.horizontal(toView: cardLabel)
            nameTextField.horizontal(toView: cardLabel)
            expiryDateTextField.left(toView: cardLabel)
            
            cvvTextField.leftHorizontalSpacing(toView: expiryDateTextField, space: -16)
            cvvTextField.top(toView: expiryDateTextField)
            cvvTextField.right(toView: view, space: -16)
            cvvTextField.width(toView: expiryDateTextField)
            
            cardNumberTextField.height(50)
            nameTextField.height(toView: cardNumberTextField)
            expiryDateTextField.height(toView: cardNumberTextField)
            cvvTextField.height(toView: cardNumberTextField)
            
            return view
        }
        
        func coverExpiry() -> UIButton {
            let button = UIMaker.makeButton()
            expiryDateTextField.addSubviews(views: button)
            button.fill(toView: expiryDateTextField)
            return button
        }
    }
}
