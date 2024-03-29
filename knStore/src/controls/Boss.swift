//
//  Boss.swift
//  SnapShop
//
//  Created by Ky Nguyen on 9/29/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit
let tabHeight: CGFloat = hasNotch() ? 49 : 66
var tabBoss: KNTabBoss?
extension UIViewController {
    func setTab(visible: Bool) {
        tabBoss?.KN_tabBar.isHidden = !visible
        tabBoss?.tabBar.isHidden = true
    }
}
class KNTabBoss: KNTabController {
    override func setupView() {
        let itemHeight: CGFloat = 44
        let font = UIFont.systemFont(ofSize: 10)
        
        // define tab items
        let storiesTab = KNTabBarItem(icon: #imageLiteral(resourceName: "home"), title: "HOME", font: font)
        storiesTab.itemHeight = itemHeight

        // define tab controllers
        let stories = wrap(UIViewController())
        
        setTabBar(items: [storiesTab], height: tabHeight)
        viewControllers = [stories]
        normalColor = UIColor(value: 178)
        selectedColor = UIColor(value: 29)

        KN_tabBar.backgroundColor = .white
        selectedIndex = 1
        
        tabBoss = self
    }
    
    fileprivate func wrap(_ controller: UIViewController) -> UINavigationController {
        let controller = UINavigationController(rootViewController: controller)
        controller.isNavigationBarHidden = true
        return controller
    }
}
