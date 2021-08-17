//  Created by Ky Nguyen

import UIKit

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    class func present(_ controller: UIViewController) {
        let topController = topViewController()
        topController?.present(controller)
    }
    
    class func push(_ controller: UIViewController) {
        let topController = topViewController()
        topController?.push(controller)
    }
}
