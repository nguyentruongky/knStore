//
//  SystemSetting.swift
//  invo-ios
//
//  Created by Ky Nguyen Coinhako on 8/29/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import Foundation
import UIKit

class SystemSetting {
    static func openAppSetting() {
        if let url = URL(string:UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func openWifi() {
        if let url = URL(string:"App-Prefs:root=WIFI") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
