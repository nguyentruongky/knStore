//
//  NavigationExtension.swift
//  knStore
//
//  Created by Ky Nguyen Coinhako on 12/11/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
}

extension UINavigationController {
    func hideBar(_ hide: Bool) {
        UIView.animate(withDuration: 0.35,
                       animations: { [weak self] in
                        self?.isNavigationBarHidden = hide })
    }
    
    func hideBarWhenScrolling(inScrollView scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if actualPosition.y > 0 {
            setNavigationBarHidden(false, animated: true)
            return
        }
        setNavigationBarHidden(scrollView.contentOffset.y > 24, animated: true)
    }
    
    func changeTitleFont(_ font: UIFont, color: UIColor = .white) {
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font]
    }
    
    func removeLine(color: UIColor = .white, titleColor: UIColor = .black) {
        navigationBar.setBackgroundImage(UIImage.createImage(from: color), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = titleColor
    }
    
    func fillNavigationBar(withColors colors: [CGColor],
                           startPoint: CGPoint = CGPoint(x: 0, y: 0),
                           endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = navigationBar.bounds
        updatedFrame.size.height += 20
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        let image = gradientLayer.renderImage()
        navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }
}

/// Extend navigation bar height
extension UINavigationController {
//    var statusBarView: UIView? {
//        return view.viewWithTag(999)
//    }
//    
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        if hasNotch() == false {
//            let statusBarView = UIView(frame: CGRect(x: 0, y: -38, width: screenWidth, height: 20))
//            statusBarView.tag = 999
//            statusBarView.backgroundColor = .white
//            navigationBar.addSubview(statusBarView)
//        }
//    }
//    
//    override open func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if hasNotch() == false {
//            let height = CGFloat(48)
//            navigationBar.frame = CGRect(x: 0, y: 38, width: screenWidth, height: height)
//        }
//    }
}
