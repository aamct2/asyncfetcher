//
//  AppDelegate.swift
//  iOS Example
//
//  Created by Aaron McTavish on 29/04/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController(rootViewController: ViewController())

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}
