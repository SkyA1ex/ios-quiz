//
//  AppDelegate.swift
//  Quiz
//
//  Created by Alexander Tkachenko on 20/04/17.
//  Copyright (c) 2017 Alexander Tkachenko. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
            [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FIRApp.configure()


        return true
    }




}
