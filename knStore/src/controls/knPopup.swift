//
//  KNPopup.swift
//  KNPopup
//
//  Created by Ky Nguyen Coinhako on 10/9/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

protocol KNPopupDelegate: class {
    func didSelectOK()
}

class KNPopup: KNView {
    weak var delegate: KNPopupDelegate?
    
    let blackView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.clipsToBounds = true
        return v
    }()
    let okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.backgroundColor = UIColor(r: 71, g: 204, b: 54)
        button.height(54)
        button.setCorner(radius: 27)
        return button
    }()
    
    override func setupView() {}
    
    func show(in view: UIView) {
        hideKeyboard()
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        addSubviews(views: blackView, container)
        blackView.fill(toView: self)
        container.centerY(toView: self)
        container.horizontal(toView: self, space: 24)
        
        blackView.alpha = 0
        UIView.animate(withDuration: 0.1, animations:
            { [weak self] in self?.blackView.alpha = 1 })
        container.zoomIn(true)
        
        view.addSubviews(views: self)
        fill(toView: view)
    }
    
    @objc func dismiss() {
        let initialValue: CGFloat = 1
        let middleValue: CGFloat = 1.025
        let endValue: CGFloat = 0.001
        func fadeOutContainer() {
            UIView.animate(withDuration: 0.2, animations:
                { [weak self] in self?.container.alpha = 0 })
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
                    self?.blackView.alpha = 0
                }, completion: { [weak self] _ in self?.removeFromSuperview() })
        }
        
        container.transform = container.transform.scaledBy(x: initialValue , y: initialValue)
        fadeOutContainer()
        zoomInContainer()
        zoomOutContainer()
    }
}

