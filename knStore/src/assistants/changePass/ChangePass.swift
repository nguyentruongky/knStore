//
//  ChangePass.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 11/8/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

class snChangePassCtr: knStaticListController {
    let ui = UI()
    lazy var output = Interactor(controller: self)
    
    override func setupView() {
        title = "CHANGE PASSWORD"
        addBackButton(tintColor: UIColor(value: 29))
        
        navigationController?.hideBar(false)
        super.setupView()
        view.addSubviews(views: tableView)
        tableView.horizontalSuperview()
        tableView.top(toSafeAreaWithSpace: 32)
        tableView.bottomSuperView()
        datasource = ui.setupView()
        
        view.addSubviews(views: ui.saveButton)
        ui.saveButton.horizontal(toView: view, space: 16)
        ui.saveButton.bottom(toView: view, space: -54)
        
        ui.saveButton.addTarget(self, action: #selector(saveChanges))
        ui.updatePass = { [weak self] in self?.saveChanges() }
    }
    
    @objc func saveChanges(){
        hideKeyboard()
        let validation = Validation()
        validation.oldPass = ui.oldPassTextField.text
        validation.newPass = ui.newPassTextField.text
        validation.confirmPass = ui.confirmPassTextField.text
        let result = validation.validate()
        if result.isValid == false {
            Messenger.showError(result.error!)
            return
        }
        
        ui.saveButton.setProcess(visible: true)
        output.updatePass(old: validation.oldPass!, new: validation.newPass!, confirm: validation.confirmPass!)
    }
}

extension snChangePassCtr {
    func didChange(message: String) {
        ui.saveButton.setProcess(visible: false)
        Messenger.showMessage(message)
    }
    
    func didChangeFail(_ err: knError) {
        ui.saveButton.setProcess(visible: false)
        Messenger.showError(err.message ?? Messenger.defaultError)
    }
    
    class Validation {
        var oldPass: String?
        var newPass: String?
        var confirmPass: String?
        func validate() -> (isValid: Bool, error: String?) {
            let emptyMessage = "%@ can't be empty"
            if oldPass == nil || oldPass?.isEmpty == true {
                return (false, String(format: emptyMessage, "Old Password")) }
            if newPass == nil || newPass?.isEmpty == true {
                return (false, String(format: emptyMessage, "New Password")) }
            if confirmPass == nil || confirmPass?.isEmpty == true  {
                return (false, String(format: emptyMessage, "Confirm New Password")) }
            
            let passwordCheck = knPasswordValidation()
            let upperRule = "%@ must have at least 1 Uppercase character"
            let digitRule = "%@ must have at least 1 digit"
            
            if passwordCheck.checkUpperCase(newPass!) == false {
                return (false, String(format: upperRule, "New Password")) }
            if passwordCheck.checkNumberDigit(newPass!) == false {
                return (false, String(format: digitRule, "New Password")) }
            
            if passwordCheck.checkUpperCase(confirmPass!) == false {
                return (false, String(format: upperRule, "Confirm New Password")) }
            if passwordCheck.checkNumberDigit(confirmPass!) == false {
                return (false, String(format: digitRule, "Confirm New Password")) }
            
            if newPass != confirmPass {
                return (false, "New Password is not match") }
            
            if newPass == oldPass {
                return (false, "New Password must be different to your current password") }
            
            return (true, nil)
        }
    }
}

extension snChangePassCtr {
    class Interactor {
        func updatePass(old: String, new: String, confirm: String) {
            knChangePassWorker(oldPass: old, newPass: new, confirmPass: confirm, success: output?.didChange, fail: output?.didChangeFail).execute()
        }
        
        private weak var output: Controller?
        init(controller: Controller) { output = controller }
    }
    typealias Controller = snChangePassCtr
}
