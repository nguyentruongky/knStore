//
//  ViewController.swift
//  KNTabController
//
//  Created by Ky Nguyen on 4/7/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class KNTabBarItem: UIButton {
    var itemHeight: CGFloat = 0
    var lock = false
//    let line = UIMaker.makeLine(height: 2)
    var color: UIColor = UIColor.lightGray {
        didSet {
            guard lock == false else { return }
            iconImageView.image = iconImageView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            iconImageView.tintColor = color
            textLabel.textColor = color
//            line.backgroundColor = color
        }}
    
//    func setIndicator(visible: Bool) {
//        line.isHidden = !visible
//    }
    
    private let iconImageView = UIMaker.makeImageView(contentMode: .scaleAspectFit)
    private let textLabel = UIMaker.makeLabel(font: UIFont.systemFont(ofSize: 11),
                                        color: .black, alignment: .center)
    
    convenience init(icon: UIImage, title: String,
                     font: UIFont = UIFont.systemFont(ofSize: 11)) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = icon
        textLabel.text = title
        textLabel.font = font
        setupView()
    }
    
    private func setupView() {
        addSubviews(views: iconImageView, textLabel)
//        addSubviews(views: line)
        iconImageView.top(toView: self, space: 4)
        iconImageView.centerX(toView: self)
        iconImageView.square()
        
        let iconBottomConstant: CGFloat = textLabel.text == "" ? -2 : -20
        iconImageView.bottom(toView: self, space: iconBottomConstant)
        
        textLabel.bottom(toView: self, space: -2)
        textLabel.centerX(toView: self)
        
//        line.centerX(toView: self)
//        line.bottom(toView: self, space: 10)
//        line.width(32)
//        line.isHidden = true
    }
}

class KNTabBar: UITabBar {
    var KN_items = [KNTabBarItem]()
    convenience init(items: [KNTabBarItem]) {
        self.init()
        KN_items = items
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    override var tintColor: UIColor! {
        didSet {
            for item in KN_items {
                item.color = tintColor
            }}}
    
    func setupView() {
        removeLine()
        backgroundColor = .white
        if KN_items.count == 0 { return }
        
        let line = UIMaker.makeHorizontalLine(height: 0.5)
        addSubviews(views: line)
        line.horizontal(toView: self)
        line.top(toView: self)
        
        var horizontalConstraints = "H:|"
        let itemWidth: CGFloat = screenWidth / CGFloat(KN_items.count)
        for i in 0 ..< KN_items.count {
            let item = KN_items[i]
            addSubviews(views: item)
            if item.itemHeight == 0 {
                item.vertical(toView: self)
            } else {
                item.centerY(toView: self)
                item.height(item.itemHeight)
            }
            item.width(itemWidth)
            horizontalConstraints += String(format: "[v%d]", i)
            if item.lock == false {
                item.color = tintColor
            }
        }
        
        horizontalConstraints += "|"
        addConstraints(withFormat: horizontalConstraints, arrayOf: KN_items)
    }
}

class KNTabController: UITabBarController {
    var KN_tabBar: KNTabBar!
    var selectedColor = UIColor.darkGray
    var normalColor = UIColor.lightGray {
        didSet {
            KN_tabBar.tintColor = normalColor
        }}
    
    override var selectedIndex: Int { didSet {
        let item = KN_tabBar.KN_items[selectedIndex]
        item.color = selectedColor
//        item.setIndicator(visible: true)
        }}
    private var KN_tabBarHeight: CGFloat = 49
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        setupView()
    }
    
    func setupView() {}
    
    func setTabBar(items: [KNTabBarItem], height: CGFloat = 49) {
        guard items.count > 0 else { return }
        
        KN_tabBar = KNTabBar(items: items)
        guard let bar = KN_tabBar else { return }
        KN_tabBar.barTintColor = .white
        KN_tabBar.tintColor = normalColor
        bar.KN_items.first?.color = selectedColor
        
        view.addSubviews(views: bar)
        bar.horizontal(toView: view)
        if #available(iOS 11.0, *) {
            bar.bottom(toAnchor: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            bar.bottom(toView: view)
        }
        KN_tabBarHeight = height
        bar.height(KN_tabBarHeight)
        for i in 0 ..< items.count {
            let item = items[i]
            item.tag = i
            item.addTarget(self, action: #selector(switchTab), for: .touchUpInside)
        }
    }
    
    @objc func switchTab(button: UIButton) {
        let newIndex = button.tag
        changeTab(from: selectedIndex, to: newIndex)
    }
    
    private func changeTab(from fromIndex: Int, to toIndex: Int) {
        let oldItem = KN_tabBar.KN_items[fromIndex]
//        oldItem.setIndicator(visible: false)
        oldItem.color = normalColor
        KN_tabBar.KN_items[toIndex].color = selectedColor
        animateSliding(from: fromIndex, to: toIndex)
    }
}

extension KNTabController {

    func animateSliding(from fromIndex: Int, to toIndex: Int) {
        guard fromIndex != toIndex else { return }
        guard let fromController = viewControllers?[fromIndex], let toController = viewControllers?[toIndex] else { return }
        let fromView = fromController.view!
        let toView = toController.view!
        let viewSize = fromView.frame
        let scrollRight = fromIndex < toIndex
        fromView.superview?.addSubview(toView)
        toView.frame = CGRect(x: scrollRight ? screenWidth : -screenWidth,
                              y: viewSize.origin.y,
                              width: screenWidth,
                              height: viewSize.height)
        
        func animate() {
            fromView.frame = CGRect(x: scrollRight ? -screenWidth : screenWidth,
                                    y: viewSize.origin.y,
                                    width: screenWidth,
                                    height: viewSize.height)
            toView.frame = CGRect(x: 0,
                                  y: viewSize.origin.y,
                                  width: screenWidth,
                                  height: viewSize.height)
        }
        
        func finished(_ completed: Bool) {
            fromView.removeFromSuperview()
            selectedIndex = toIndex
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut,
                       animations: animate, completion: finished)
    }
}
