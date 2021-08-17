//  Created by Ky Nguyen

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
    
    func getJson(from file: String) -> AnyObject? {
        guard let filePath = path(forResource: file, ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return jsonResult as AnyObject
        } catch { return nil }
    }
}


extension UITabBar {
    func removeLine() {
        shadowImage = UIImage()
        backgroundImage = UIImage()
    }
}

extension UITabBarController {
    func setTabBar(visible: Bool) {
        tabBar.frame.size.height = visible ? 49 : 0
        tabBar.isHidden = !visible
    }
}


extension UserDefaults {
    static func set<T>(key: String, value: T?) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func get<T>(key: String) -> T? {
        return UserDefaults.standard.value(forKeyPath: key) as? T
    }
}

