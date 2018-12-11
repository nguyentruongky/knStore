//
//  AddCard.swift
//  invo-ios
//
//  Created by Ky Nguyen Coinhako on 11/28/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class INAddCardCtr: knStaticListController {
    let ui = UI()
    let cardHandler = snCardNumberHandler()
    let nameHandler = snNameHandler()
    let cvvHandler = snCVVHandler()
    var expireDates = [String]()
    
    override func setupView() {
        navigationController?.hideBar(false)
        addBackButton(tintColor: .white)
        super.setupView()
        view.addSubviews(views: tableView)
        tableView.fill(toView: view, space: UIEdgeInsets(top: 66))
        datasource = ui.setupView()
        let color = UIColor(r: 243, g: 245, b: 248)
        tableView.backgroundColor = color
        view.backgroundColor = color
        
        view.addSubviews(views: ui.saveButton)
        ui.saveButton.horizontal(toView: view, space: 16)
        ui.saveButton.bottom(toView: view, space: -54)
        
        ui.cardNumberTextField.delegate = cardHandler
        ui.nameTextField.delegate = nameHandler
        ui.cvvTextField.delegate = cvvHandler
        
        let button = ui.coverExpiry()
        button.addTarget(self, action: #selector(showExpiryDatePicker))
    }
    
    
    override func back() {
        dismissBack()
    }
    
    @objc func showExpiryDatePicker() {
        expireDates = snGetExpiryDateWorker().execute()
        ui.datePicker.delegate = self
        ui.datePicker.updateDatasource(expireDates)
        ui.datePicker.show(in: self)
    }
}

extension INAddCardCtr: knPickerViewDelegate {
    func didSelectText(_ text: String) {
        ui.expiryDateTextField.text = text
    }
}

