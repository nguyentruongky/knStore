//  Created by Ky Nguyen

import UIKit
import SwiftyDrop

extension Messenger {
    static func presentMessage(_ message: String?, title: String? = nil,
                            cancelActionName: String? = "OK") {
        let controller = getMessage(message, title: title, cancelActionName: cancelActionName)
        UIApplication.topViewController()?.present(controller)
    }

    static func showError(_ message: String) {
        Drop.down(message, state: .error, duration: 3)
    }

    static func showMessage(_ message: String) {
        Drop.down(message, state: .info, duration: 3)
    }
}

