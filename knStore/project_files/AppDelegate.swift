//
//  AppDelegate.swift
//  KNStore
//
//  Created by Ky Nguyen Coinhako on 12/10/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = wrap(LoginCtr())
        return true
    }
}

