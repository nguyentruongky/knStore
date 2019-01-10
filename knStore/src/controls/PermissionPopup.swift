//
//  PermissionPopup.swift
//  invo-ios
//
//  Created by Ky Nguyen Coinhako on 8/29/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit
class knPermissionPopup: knView {
    let padding: CGFloat = 24
    enum Permission {
        case location, calendar, notification, contact
    }
    
    private var permission = Permission.location
    private let dismissButton = UIMaker.makeButton()
    private let messageLabel = UIMaker.makeLabel(font: UIFont.main(.medium, size: 16),
                                                   color: UIColor(value: 34),
                                                   numberOfLines: 0,
                                                   alignment: .center)
    func setMessage(_ message: String, permission: Permission) {
        messageLabel.text = message
        messageLabel.setLineSpacing()
        self.permission = permission
        var step2: UIView!
        var step3: UIView!
        switch permission {
        case .notification:
            step2 = makeStep(icon: #imageLiteral(resourceName: "ios_notification"), text: "2. Tap Notifications.")
            step3 = makeStep(icon: #imageLiteral(resourceName: "ios_switch"), text: "3. Set \"Allow Notifications\" to On.")
        case .calendar:
            step2 = makeStep(icon: #imageLiteral(resourceName: "ios_switch"), text: "2. Set \"Allow Calendars\" to On.")
        case .location:
            step2 = makeStep(icon: #imageLiteral(resourceName: "ios_location"), text: "2. Tap Location")
            step3 = makeStep(icon: #imageLiteral(resourceName: "ios_check"), text: "3. Check on \"While Using the App\".")
        case .contact:
            step2 = makeStep(icon: #imageLiteral(resourceName: "ios_switch"), text: "2. Set \"Allow Contacts\" to On.")
        }
        
        stepsView.addViews(step2)
        step2.horizontal(toView: stepsView)
        
        if let step3 = step3 {
            stepsView.addViews(step3)
            step3.horizontal(toView: stepsView)
        }
        
    }
    
    func makeStep(icon: UIImage, text: String) -> UIView {
        let view = UIMaker.makeView()
        let imgView = UIMaker.makeImageView(image: icon)
        let label = UIMaker.makeLabel(text: text, font: UIFont.main(),
                                        color: UIColor(value: 34), numberOfLines: 0)
        view.addSubviews(views: imgView, label)
        view.addConstraints(withFormat: "H:|-24-[v0]-12-[v1]-24-|", views: imgView, label)
        imgView.square(edge: 32)
        imgView.centerY(toView: view)
        label.vertical(toView: view, space: 8)
        
        return view
    }
    let stepsView = UIMaker.makeStackView()
    let container = UIMaker.makeView(background: .white)

    override func setupView() {
        let step1 = makeStep(icon: #imageLiteral(resourceName: "ios_setting"), text: "1. Go to Setting.")
        stepsView.addViews(step1)
        step1.horizontal(toView: stepsView)
        
        let openSettingButton = UIMaker.makeMainButton(title: "Open Settings")
        let closeButton = UIMaker.makeButton(title: "Close",
                                               titleColor: UIColor(value: 123),
                                               font: UIFont.main())
        
        container.addSubviews(views: messageLabel, stepsView, openSettingButton, closeButton)
        container.addConstraints(withFormat: "V:|-24-[v0]-16-[v1]-24-[v2]-16-[v3]-24-|",
                            views: messageLabel, stepsView, openSettingButton, closeButton)
        messageLabel.horizontal(toView: container, space: padding)
        stepsView.horizontal(toView: container)
        openSettingButton.horizontal(toView: messageLabel)
        closeButton.width(screenWidth / 2.5)
        closeButton.centerX(toView: container)
        closeButton.centerX(toView: container)
        
        container.setCorner(radius: 8)
        
        dismissButton.backgroundColor = UIColor.black.alpha(0.5)
        addSubviews(views: dismissButton, container)
        dismissButton.fill(toView: self)
        container.horizontal(toView: self, space: padding)
        container.centerY(toView: self)
        
        closeButton.addTarget(self, action: #selector(close))
        dismissButton.addTarget(self, action: #selector(close))
        openSettingButton.addTarget(self, action: #selector(openSettings))
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

    @objc func openSettings() {
        SystemSetting.openAppSetting()
    }
}






