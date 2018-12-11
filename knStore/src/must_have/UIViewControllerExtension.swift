//
//  UIViewController.swift
//  kLibrary
//
//  Created by Ky Nguyen on 8/27/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func setEnabled(_ enabled: Bool) {
        view.isUserInteractionEnabled = enabled
    }
    
    private func createFakeBackButton() -> [UIBarButtonItem] {
        let height: CGFloat = 36
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: height))
        let image = UIImage(named: "back_arrow")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 36, height: height)
        backView.addSubview(imageView)
        let content = UILabel()
        content.sizeToFit()
        content.frame.size = CGSize(width: content.frame.size.width, height: height)
        content.frame.origin = CGPoint(x: 30, y: 0)
        backView.addSubview(content)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: height))
        button.addTarget(self, action: #selector(dismissBack), for: .touchUpInside)
        backView.addSubview(button)
        
        let barButton = UIBarButtonItem(customView: backView)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -20
        
        return [negativeSpacer, barButton]
    }
    
    func addFakeBackButton() {
        navigationItem.leftBarButtonItems = createFakeBackButton()
    }
    
    @objc func dismissBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @discardableResult
    func addBackButton(tintColor: UIColor = .black) -> UIBarButtonItem {
        let backArrowImageView = UIImageView(image: UIImage(named: "back_arrow")?.changeColor())
        backArrowImageView.contentMode = .scaleAspectFit
        backArrowImageView.tintColor = tintColor
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        backButton.addSubview(backArrowImageView)
        backButton.addConstraints(withFormat: "H:|-(-4)-[v0]", views: backArrowImageView)
        backArrowImageView.vertical(toView: backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
        return backBarButton
    }
    
    @objc func back() {
        pop()
    }

    func present(_ controller: UIViewController) {
        present(controller, animated: true)
    }

    func push(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func pop(to controller: UIViewController) {
        navigationController?.popToViewController(controller, animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }

}

extension UITableViewController {
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        for cell in cells {
            UIView.animate(withDuration: 1.25, delay: 0.05 * Double(index),
                                       usingSpringWithDamping: 0.65,
                                       initialSpringVelocity: 0.0,
                                       options: UIView.AnimationOptions(),
                                       animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            index += 1
        }
    }
}

extension UITabBarController {
    func setTabBar(visible: Bool) {
        tabBar.frame.size.height = visible ? 49 : 0
        tabBar.isHidden = !visible
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
