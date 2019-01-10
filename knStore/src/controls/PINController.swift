//
//  PINController.swift
//  Coinhako
//
//  Created by Ky Nguyen on 9/12/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import UIKit

protocol coinProtector: class {
    var backButton: UIButton { get set }
    var successAction: (() -> ())? { get set }
    var loginAuthenticate: Bool { get set }
}

enum PINUsage {
    case setup, authenticate, confirm, tradingAuthenticate
}

class PINController: knController, coinProtector {
    var loginAuthenticate: Bool = false
    var successAction: (() -> ())?
    
    let pinTextField = UIMaker.makeTextField(text: "create_pin".i18n, font: UIFont.main(),
                                             color: .white)
    
    func makeButton(title: String) -> UIButton {
        let button = UIMaker.makeButton(title: title, titleColor: .white, font: UIFont.main(size: 25))
        button.square(edge: 60)
        button.setCorner(radius: 30)
        button.setBorder(1, color: .white)
        button.addTarget(self, action: #selector(didTapButton))
        return button
    }
    
    var dots = [UIView]()
    let pinLength = 6
    var pin = "" {
        didSet {
            
            cancelButton.isHidden = pin.count != 0
            deleteButton.isHidden = pin.count == 0

            let count = pin.count
            for i in 0 ..< count {
                dots[i].backgroundColor = .white
            }
            
            for i in count ..< pinLength {
                dots[i].backgroundColor = .clear
            }
        }
    }
    
    
    @objc func didTapButton(button: UIButton) {
        
        guard pin.count < pinLength else { return }
        
        if usage == .setup || usage == .confirm {
            pinTextField.isHidden = true
            dotsView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.0, animations: { button.backgroundColor = .lightGray },
                       completion: { _ in button.backgroundColor = .clear })
        pin += button.titleLabel!.text!
        
        if pin.count == pinLength {
            didFinishEnterPIN()
        }
    }
    
    func didFinishEnterPIN() { }
    
    var usage = PINUsage.authenticate {
        didSet {
            
            if usage == .tradingAuthenticate {
                titleLabel.text = "authentication".i18n
                dotsView.isHidden = false
                pinTextField.isHidden = true
                return
            }
            
            if usage == .authenticate {
                titleLabel.text = "authentication".i18n
                dotsView.isHidden = false
                pinTextField.isHidden = true
                cancelButton.removeFromSuperview()
                return
            }
            
            if usage == .setup {
                dotsView.isHidden = false
                pinTextField.isHidden = true
                titleLabel.text = "create_pin".i18n
                cancelButton.isHidden = true
                cancelButton.removeFromSuperview()
                return
            }
            
            if usage == .confirm {
                dotsView.isHidden = false
                pinTextField.isHidden = true
                titleLabel.text = "confirm_pin".i18n
                cancelButton.isHidden = true
                cancelButton.removeFromSuperview()
                return
            }
            
        }
    }
    
    func makeCharacterIndicator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCorner(radius: 7)
        view.square(edge: 14)
        view.setBorder(1, color: .white)
        return view
    }
    
    lazy var dot0: UIView = self.makeCharacterIndicator()
    lazy var dot1: UIView = self.makeCharacterIndicator()
    lazy var dot2: UIView = self.makeCharacterIndicator()
    lazy var dot3: UIView = self.makeCharacterIndicator()
    lazy var dot4: UIView = self.makeCharacterIndicator()
    lazy var dot5: UIView = self.makeCharacterIndicator()
    
    lazy var button0: UIButton = self.makeButton(title: "0")
    lazy var button1: UIButton = self.makeButton(title: "1")
    lazy var button2: UIButton = self.makeButton(title: "2")
    lazy var button3: UIButton = self.makeButton(title: "3")
    lazy var button4: UIButton = self.makeButton(title: "4")
    lazy var button5: UIButton = self.makeButton(title: "5")
    lazy var button6: UIButton = self.makeButton(title: "6")
    lazy var button7: UIButton = self.makeButton(title: "7")
    lazy var button8: UIButton = self.makeButton(title: "8")
    lazy var button9: UIButton = self.makeButton(title: "9")
    
    lazy var cancelButton: UIButton = self.makeActionTextButton(title: "cancel".i18n)
    lazy var deleteButton: UIButton = self.makeActionTextButton(title: "delete".i18n)
    
    func makeActionTextButton(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.main(.bold, size: 15)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        statusBarStyle = .lightContent
    }
    
    @objc func handleDelete() {
        guard pin.count > 1 else { pin = ""; return }
        pin = pin.substring(to: pin.count - 1)
    }
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    let dotsView = UIView()

    var backButton: UIButton = UIMaker.makeButton(image: UIImage(named: "back_arrow"))
    let titleLabel = UIMaker.makeLabel()
    override func setupView() {
        
        titleLabel.text = "authentication".i18n
        titleLabel.font = UIFont.main(size: 18)
        titleLabel.textColor = .white
        
        backButton.addTarget(self, action: #selector(back))
        deleteButton.addTarget(self, action: #selector(handleDelete))
        cancelButton.addTarget(self, action: #selector(handleCancel))
        
        navigationController?.hideBar(true)
      
        view.addSubviews(views: titleLabel, backButton)
        titleLabel.centerX(toView: view)
        titleLabel.centerY(toView: backButton)
        
        backButton.square(edge: 44)
        backButton.topLeft(toView: view, top: hasNotch() ? 48 : 32, left: 12)
        
        view.backgroundColor = UIColor(r: 44, g: 69, b: 125)
        
        dots.append(contentsOf: [dot0, dot1, dot2, dot3, dot4, dot5])
        
        let dotPadding: CGFloat = 16
        dotsView.translatesAutoresizingMaskIntoConstraints = false
        dotsView.addSubviews(views: dot0, dot1, dot2, dot3, dot4, dot5)
        dotsView.addConstraints(withFormat: "H:|[v0]-\(dotPadding)-[v1]-\(dotPadding)-[v2]-\(dotPadding)-[v3]-\(dotPadding)-[v4]-\(dotPadding)-[v5]|", views: dot0, dot1, dot2, dot3, dot4, dot5)
        dot0.vertical(toView: dotsView)
        dot1.vertical(toView: dotsView)
        dot2.vertical(toView: dotsView)
        dot3.vertical(toView: dotsView)
        dot4.vertical(toView: dotsView)
        dot5.vertical(toView: dotsView)
        
        view.addSubviews(views: dotsView, pinTextField)
        dotsView.centerX(toView: view)
        dotsView.top(toView: view, space: DeviceType.IS_IPHONE_5_OR_LESS ? 120 : 150)
        
        pinTextField.center(toView: dotsView)
        
        let numberPadding: CGFloat = 30
        let numberPad = UIView()
        numberPad.translatesAutoresizingMaskIntoConstraints = false
        numberPad.addSubviews(views: button0, button1, button2, button3,
                              button4, button5, button6, button7, button8, button9)
        
        button1.topLeft(toView: numberPad)
        
        numberPad.addConstraints(withFormat: "H:|[v0]-\(numberPadding)-[v1]-\(numberPadding)-[v2]|",
            views: button1, button2, button3)
        
        button2.top(toView: button1)
        button2.centerX(toView: numberPad)
        
        button3.topRight(toView: numberPad)
        
        button4.left(toView: numberPad)
        button4.verticalSpacing(toView: button1, space: numberPadding)
        
        button5.centerY(toView: button4)
        button5.centerX(toView: button2)
        
        button6.right(toView: numberPad)
        button6.centerY(toView: button4)
        
        button7.left(toView: numberPad)
        button7.verticalSpacing(toView: button4, space: numberPadding)
        
        button8.centerX(toView: numberPad)
        button8.centerY(toView: button7)
        
        button9.right(toView: numberPad)
        button9.centerY(toView: button7)
        
        button0.centerX(toView: numberPad)
        button0.verticalSpacing(toView: button8, space: numberPadding)
        button0.bottom(toView: numberPad)
        
        view.addSubviews(views: numberPad)
        numberPad.centerX(toView: view)
        numberPad.verticalSpacing(toView: dotsView, space: 40)
        
        view.addSubviews(views: deleteButton, cancelButton)
        deleteButton.isHidden = true
        
        deleteButton.right(toView: numberPad)
        deleteButton.verticalSpacing(toView: numberPad,
                                     space: DeviceType.IS_IPHONE_5_OR_LESS ? numberPadding / 2 :  numberPadding )
        
        cancelButton.center(toView: deleteButton)
        usage = .setup
    }
    
}
















