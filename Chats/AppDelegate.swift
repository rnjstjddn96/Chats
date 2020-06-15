//
//  AppDelegate.swift
//  Chats
//
//  Created by 권성우 on 2020/06/13.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let messageController = MessageController()
        window?.rootViewController = UINavigationController(rootViewController: messageController)
        FirebaseApp.configure()
        return true
        
    }





}

