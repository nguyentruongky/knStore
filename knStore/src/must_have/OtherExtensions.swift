//
//  OtherExtensions.swift
//  Coinhako
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import UIKit

extension Optional {
    func or<T>(_ defaultValue: T) -> T {
        switch(self) {
        case .none:
            return defaultValue
        case .some(let value):
            return value as! T
        }
    }
}

extension UIBarButtonItem {
    func format(font: UIFont, textColor: UIColor) {
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor]
        setTitleTextAttributes(attributes, for: UIControl.State.normal)
    }
}

extension UILabel{
    func createSpaceBetweenLines(_ alignText: NSTextAlignment = NSTextAlignment.left, spacing: CGFloat = 7) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.alignment = .left
        
        let ats = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        attributedText = NSAttributedString(string: self.text!, attributes:ats)
        textAlignment = alignText
    }
}

extension UIScrollView {
    func animateView(animatedView: UIView, staticView: UIView) {
        var headerTransform = CATransform3DIdentity
        let yOffset = contentOffset.y
        staticView.isHidden = yOffset < 0
        animatedView.isHidden = yOffset > 0
        if yOffset < 0 {
            let headerScaleFactor:CGFloat = -(yOffset) / animatedView.bounds.height
            let headerSizevariation = ((animatedView.bounds.height * (1.0 + headerScaleFactor)) - animatedView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            animatedView.layer.transform = headerTransform
        }
    }
}

extension UITableView {
    func resizeTableHeaderView(toSize size: CGSize) {
        guard let headerView = tableHeaderView else { return }
        guard headerView.frame.size != size else { return }
        headerView.frame.size = headerView.systemLayoutSizeFitting(size)
        tableHeaderView? = headerView
    }
    
    func getCell(id: String, at indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
    
    func setFooter(_ footer: UIView, height: CGFloat) {
        footer.height(height)
        tableFooterView = UIView()
        tableFooterView?.frame.size.height = height
        tableFooterView?.addSubview(footer)
        tableFooterView?.addConstraints(withFormat: "H:|[v0]|", views: footer)
        tableFooterView?.addConstraints(withFormat: "V:|[v0]", views: footer)
    }
    
    func setHeader(_ header: UIView, height: CGFloat) {
        if height == 0 {
            tableHeaderView = UIView()
            tableHeaderView?.addSubview(header)
            header.fill(toView: tableHeaderView!)
            return
        }
        header.height(height)
        tableHeaderView = UIView()
        tableHeaderView?.frame.size.height = height
        tableHeaderView?.addSubview(header)
        tableHeaderView?.addConstraints(withFormat: "H:|[v0]|", views: header)
        tableHeaderView?.addConstraints(withFormat: "V:|[v0]", views: header)
    }
    
    func updateHeaderHeight() {
        guard let headerView = tableHeaderView else { return }
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var headerFrame = headerView.frame
        
        guard height != headerFrame.size.height else { return }
        headerFrame.size.height = height
        headerView.frame = headerFrame
        tableHeaderView = headerView
    }
    
    func updateFooterHeight() {
        guard let footerView = tableFooterView else { return }
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var footerFrame = footerView.frame
        
        guard height != footerFrame.size.height else { return }
        footerFrame.size.height = height
        footerView.frame = footerFrame
        tableFooterView = footerView
    }
}

extension UITextView {
    func wrapText(aroundRect rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        textContainer.exclusionPaths = [path]
    }
}

extension Bundle {
    var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}


extension UITabBar {
    func removeLine() {
        shadowImage = UIImage()
        backgroundImage = UIImage()
    }
}

extension UserDefaults {
    static func set<T>(key: String, value: T?) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func getString(key: String) -> String? {
        return UserDefaults.standard.value(forKeyPath: key) as? String
    }
    
    static func setBool(key: String, value: Bool?) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func getBool(key: String, defaultValue: Bool = false) -> Bool {
        guard let value = UserDefaults.standard.value(forKeyPath: key) as? Bool else { return defaultValue }
        return value
    }
    
    static func getInt(key: String) -> Int? {
        return UserDefaults.standard.value(forKeyPath: key) as? Int
    }
}


extension UIStackView {
    func addViews(_ views: UIView...) {
        for v in views {
            addArrangedSubview(v)
        }
    }
    
    func addViews(_ views: [UIView]) {
        for v in views {
            addArrangedSubview(v)
        }
    }
}
