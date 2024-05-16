//
//  AppDelegate.swift
//  Shuffle Game
//
//  Created by Sepehr on 5/16/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainMenu()
        window?.makeKeyAndVisible()
        
        return true
    }
}

