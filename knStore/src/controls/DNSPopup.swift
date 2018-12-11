//
//  MessagePopup.swift
//  Coinhako
//
//  Created by Ky Nguyen Coinhako on 9/3/18.
//  Copyright © 2018 Coinhako. All rights reserved.
//

import UIKit
typealias knInstruction = (icon: UIImage?, title: String)
private let padding: CGFloat = 24
class knDNSErrorStepCell: knListCell<knInstruction> {
    override var data: knInstruction? { didSet {
        imgView.image = data?.icon
        label.text = data?.title
        
        clearSubviews()
        addSubviews(views: label)
        label.left(toView: self, space: padding)
        if data?.icon != nil {
            addSubviews(views: imgView)
            imgView.leftHorizontalSpacing(toView: label, space: -12)
            imgView.square(edge: 20)
            imgView.centerY(toView: label, space: -4)
        } else {
            label.right(toView: self, space: -padding)
        }
        label.vertical(toView: self, space: 6)
    }}
    let imgView = UIMaker.makeImageView()
    let label = UIMaker.makeLabel(font: UIFont.main(),
                                      color: UIColor.darkGray,
                                      numberOfLines: 0)
    
}

class knDNSErrorView: knView {
    private let dismissButton = UIMaker.makeButton()
    private let messageLabel = UIMaker.makeLabel(font: UIFont.main(),
                                                   color: UIColor.darkGray,
                                                   numberOfLines: 0,
                                                   alignment: .center)
    let stepsView = knListView<knDNSErrorStepCell, knInstruction>()
    let container = UIMaker.makeView(background: .white)
    
    private func setMessage() {
        messageLabel.text = "Error connecting to DNS Server. Please follow these steps and retry."
        messageLabel.setLineSpacing()
        let step1 = makeStep(icon: #imageLiteral(resourceName: "ios_setting"), text: "1. Go to Settings ")
        let step2 = makeStep(text: "2. Click \"Wi-Fi\"")
        let step3 = makeStep(text: "3. Select your connected Wi-Fi.")
        let step4 = makeStep(text: "4. Click \"Configure DNS\".")
        let step5 = makeStep(text: "5. Click \"Manual\".")
        let step6 = makeStep(text: "6. Remove all DNS Servers")
        let step7 = makeStep(text: "7. Click \"Add Server\" and key in 8.8.8.8.")
        let step8 = makeStep(text: "8. Click \"Save\" and retry.")
        stepsView.datasource = [step1, step2, step3, step4, step5, step6, step7, step8]
    }
    
    private func makeStep(icon: UIImage? = nil, text: String) -> knInstruction {
        return (icon, text)
    }
    
    override func setupView() {
        let openSettingButton = UIMaker.makeMainButton(title: "Open Settings")
        let closeButton = UIMaker.makeButton(title: "Close",
                                               titleColor: UIColor.black,
                                               font: UIFont.main())
        
        container.addSubviews(views: messageLabel, stepsView, openSettingButton, closeButton)
        container.addConstraints(withFormat: "V:|-24-[v0]-16-[v1]-24-[v2]-16-[v3]-24-|",
                                 views: messageLabel, stepsView, openSettingButton, closeButton)
        messageLabel.horizontal(toView: container, space: padding)
        stepsView.horizontal(toView: container)
        stepsView.height(screenHeight / 2.5)
        
        openSettingButton.horizontal(toView: messageLabel)
        openSettingButton.height(54)
        closeButton.width(screenWidth / 2.5)
        closeButton.centerX(toView: container)
        closeButton.centerX(toView: container)
        
        container.setRoundCorner(8)
        
        dismissButton.backgroundColor = UIColor.black.alpha(0.5)
        addSubviews(views: dismissButton, container)
        dismissButton.fill(toView: self)
        container.horizontal(toView: self, space: padding)
        container.centerY(toView: self)
        
        closeButton.addTarget(self, action: #selector(close))
        dismissButton.addTarget(self, action: #selector(close))
//        openSettingButton.addTarget(self, action: #selector(openSettings))
        openSettingButton.isHidden = true
        
        setMessage()
        
        let bottomView = UIMaker.makeView(background: .white)
        let moreButton = UIMaker.makeImageView(image: #imageLiteral(resourceName: "down-arrow"), contentMode: .scaleAspectFit)
        bottomView.addSubview(moreButton)
        moreButton.square(edge: 32)
        moreButton.centerX(toView: bottomView)
        moreButton.vertical(toView: bottomView)
        
        stepsView.addSubview(bottomView)
        bottomView.horizontal(toView: stepsView)
        bottomView.bottom(toView: stepsView)
        stepsView.tableView.contentInset = UIEdgeInsets(bottom: 48)
    }
    
    @objc func close() {
        let initialValue: CGFloat = 1
        let middleValue: CGFloat = 1.025
        let endValue: CGFloat = 0.001
        func fadeOutContainer() {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.container.alpha = 0 })
        }
        func zoomInContainer() {
            UIView.animate(withDuration: 0.05,
                           animations: { [weak self] in self?.container.scale(value: middleValue) })
        }
        func zoomOutContainer() {
            UIView.animate(withDuration: 0.3, delay: 0.05, options: .curveEaseIn,
                           animations:
                { [weak self] in
                    self?.container.scale(value: endValue)
                    self?.dismissButton.alpha = 0
                }, completion: { [weak self] _ in self?.removeFromSuperview() })
        }
        
        container.transform = container.transform.scaledBy(x: initialValue , y: initialValue)
        fadeOutContainer()
        zoomInContainer()
        zoomOutContainer()
    }
    
    func show(in view: UIView) {
        view.addSubviews(views: self)
        fill(toView: view)
        
        dismissButton.alpha = 0
        UIView.animate(withDuration: 0.1, animations: { [weak self] in self?.dismissButton.alpha = 1 })
        container.zoomIn(true)
    }
}

extension UIView {
    func zoomIn(_ isIn: Bool, complete: (() -> Void)? = nil) {
        let initialValue: CGFloat = isIn ? 0.8 : 1
        let endValue: CGFloat = isIn ? 1 : 0.8
        transform = transform.scaledBy(x: initialValue , y: initialValue)
        UIView.animate(withDuration: 0.35, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform.identity.scaledBy(x: endValue, y: endValue)
            }, completion: { _ in complete?() })
    }
    
    func scale(value: CGFloat) {
        transform = CGAffineTransform.identity.scaledBy(x: value, y: value)
    }
    
}


