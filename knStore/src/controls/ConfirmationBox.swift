//
//  ConfirmationBox.swift
//  invo-ios
//
//  Created by Ky Nguyen Coinhako on 8/22/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit
fileprivate let padding: CGFloat = 24

protocol KNConfirmationDelegate: class {
    func didConfirm()
}

class KNConfirmationBoxView: KNView {
    private let titleLabel = UIMaker.makeLabel(font: UIFont.main(.medium, size: 25),
                                                   color: UIColor(value: 34),
                                                   numberOfLines: 0,
                                                   alignment: .center)
    private let contentLabel = UIMaker.makeLabel(font: UIFont.main(),
                                                     color: UIColor(value: 84),
                                                     numberOfLines: 0,
                                                     alignment: .center)
    private let containerBackground = UIMaker.makeView(background: .white)
    private let imageView = UIMaker.makeImageView()
    private lazy var imageWrapper = makeImageWrapper()
    
    private let container = UIMaker.makeStackView()
    private let backgroundButton = UIMaker.makeButton()
    weak private var delegate: KNConfirmationDelegate?
    private let noButton = UIMaker.makeMainButton(title: "Cancel",
                                                    bgColor: .white,
                                                    titleColor: UIColor(value: 164),
                                                    font: UIFont.main(.medium))
    private let confirmButton = UIMaker.makeMainButton(title: "OK")
    func setup(title: String? = nil, content: String, icon: UIImage? = nil,
               confirmTitle: String = "Confirm",
               cancelTitle: String? = nil,
               delegate: KNConfirmationDelegate? = nil) {
        self.delegate = delegate
        confirmButton.setTitle(confirmTitle, for: .normal)
        contentLabel.text = content
        contentLabel.setLineSpacing()
        
        title == nil ? titleLabel.removeFromSuperview() : (titleLabel.text = title)
        icon == nil ? imageView.removeFromSuperview() : (imageView.image = icon)
        
        cancelTitle == nil ? noButton.removeFromSuperview() : noButton.setTitle(cancelTitle, for: .normal)
        
    }
    
    override func setupView() {
        containerBackground.setCorner(radius: 7)
        contentLabel.setLineSpacing()
        backgroundButton.backgroundColor = UIColor.black.alpha(0.5)
        backgroundButton.addTarget(self, action: #selector(close))
        
        noButton.addTarget(self, action: #selector(close))
        noButton.setBorder(width: 1, color: UIColor(value: 197))
        confirmButton.addTarget(self, action: #selector(confirm))
        
        let buttonWrapper = makeButtonWrapper()
        
        container.addViews(imageWrapper, titleLabel, contentLabel, buttonWrapper)
        imageWrapper.horizontal(toView: container)
        
        titleLabel.horizontal(toView: container, space: padding)
        contentLabel.horizontal(toView: container, space: padding)
        buttonWrapper.horizontal(toView: container, space: padding)
        
        addSubviews(views: backgroundButton, containerBackground, container)
        backgroundButton.fill(toView: self)
        
        containerBackground.fill(toView: container)
        
        if DeviceType.IS_IPAD {
            container.centerX(toView: self)
            container.width(screenWidth / 2)
        }
        else {
            container.horizontal(toView: self, space: padding)
        }
        container.centerY(toView: self)
    }
    
    private func makeButtonWrapper() -> UIView {
        let view = UIMaker.makeStackView(axis: .horizontal, distributon: .fillEqually)
        view.addViews(noButton, confirmButton)
        noButton.vertical(toView: view, topPadding: 16, bottomPadding: -padding)
        confirmButton.vertical(toView: view, topPadding: 16, bottomPadding: -padding)
        return view
    }
    
    private func makeImageWrapper() -> UIView {
        let view = UIMaker.makeView()
        view.addSubviews(views: imageView)
        imageView.vertical(toView: view, topPadding: padding, bottomPadding: 0)
        imageView.centerX(toView: view)
        imageView.square(edge: 80)
        return view
    }
    
    func show(inView view: UIView) {
        view.addSubview(self)
        fill(toView: view)
        layoutIfNeeded()
        UIView.animate(withDuration: 1.35, animations: { [weak self] in
            self?.backgroundButton.alpha = 1
            self?.container.alpha = 1
        })
    }
    
    @objc private func close() {
        removeFromSuperview()
    }

    @objc func confirm() {
        close()
        delegate?.didConfirm()
    }
}


