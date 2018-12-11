//
//  OTPView.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 3/14/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit

class knOTPView: knView {
    let padding: CGFloat = 24
    let hiddenTextField = UIMaker.makeTextField(font: UIFont.main(), color: UIColor(value: 85))
    var labels = [UILabel]()
    var boxes = [UIView]()
    var digitCount = 0
    var validate: ((String) -> Void)?
    var isInvalid = false {
        didSet {
            if isInvalid { setCodeError() }
            else {
                hiddenTextField.text = ""
                for i in 0 ..< digitCount {
                    setCode(at: i, active: false)
                    labels[i].textColor = UIColor(r: 69, g: 125, b: 245)
                    labels[i].text = ""
                }
                setCode(at: 0, active: true)
            }
        }
    }
    
    convenience init(digitCount: Int, validate: @escaping ((String) -> Void)) {
        self.init(frame: CGRect.zero)
        self.digitCount = digitCount
        self.validate = validate
        setupView()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        hiddenTextField.becomeFirstResponder()
        return true
    }
    
    override func setupView() {
        guard digitCount > 0 else { return }
        addSubviews(views: hiddenTextField)
        hiddenTextField.keyboardType = .numberPad
        hiddenTextField.isHidden = true
        hiddenTextField.fill(toView: self)
        hiddenTextField.delegate = self
        
        var constraints = "H:|-8-"
        let gapSpace = (digitCount - 1) * 8 + Int(padding) * 2
        let boxWidth: CGFloat = (screenWidth - CGFloat(gapSpace)) / CGFloat(digitCount)
        for i in 0 ..< digitCount {
            let label = makeLabel(boxWidth: boxWidth)
            labels.append(label)
            boxes.append(makeBox(for: label))
            constraints += "[v\(i)]-\(8)-"
        }
        constraints += "|"
        addConstraints(withFormat: constraints, arrayOf: boxes)
        
        makeActivateButton()
        setCode(at: 0, active: true)
        height(60)
    }
    
    func makeLabel(boxWidth: CGFloat) -> UILabel {
        let label = UIMaker.makeLabel(font: UIFont.main(size: 45),
                                          color: UIColor(r: 69, g: 125, b: 245), alignment: .center)
        label.width(boxWidth)
        return label
    }
    func makeBox(for label: UILabel) -> UIView {
        let view = UIMaker.makeView()
        view.addSubview(label)
        label.fill(toView: view)
        view.setRoundCorner(5)
        view.createBorder(0.5, color: UIColor(value: 102))
        
        addSubview(view)
        view.vertical(toView: self)
        return view
    }
    
    func clearBox() {
        for label in labels {
            label.text = ""
        }
        setCode(at: 0, active: true)
    }
    
    func makeActivateButton() {
        let button = UIMaker.makeButton()
        addSubviews(views: button)
        button.fill(toView: self)
        button.addTarget(self, action: #selector(becomeFirstResponder))
    }
}


extension knOTPView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = string
        if isInvalid {
            isInvalid = false
        }
        else {
            newText = (textField.text! as NSString).replacingCharacters(in: range,
                                                                        with: string)
        }
        let codeLength = newText.count
        guard codeLength <= digitCount else { return false }
        textField.text = newText

        func setTextToActiveBox() {
            for i in 0 ..< codeLength {
                let char = textField.text!.substring(from: i, to: i)
                labels[i].text = char
                setCode(at: i, active: true)
            }
        }

        func setTextToInactiveBox() {
            for i in codeLength ..< digitCount {
                labels[i].text = ""
                setCode(at: i, active: false)
            }
            
            if codeLength <= digitCount - 1 {
                setCode(at: codeLength, active: true)
            }
        }
        
        setTextToActiveBox()
        setTextToInactiveBox()
       
        if codeLength == digitCount {
            validateCode(code: textField.text!)
        }
        return false
    }
    
    func setCode(at index: Int, active: Bool) {
        boxes[index].createBorder(active ? 1 : 0.5,
                                  color: active ? UIColor(r: 69, g: 125, b: 245) : UIColor(value: 102))
    }
    
    func setCodeError() {
        for i in 0 ..< digitCount {
            boxes[i].createBorder(0.5, color: UIColor(r: 253, g: 102, b: 127))
            labels[i].textColor = UIColor(r: 253, g: 102, b: 127)
        }
    }
    
    func validateCode(code: String) {
        validate?(code)
    }
}
