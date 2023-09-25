//
//  AppDelegate.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let appCoordinator = AppCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appCoordinator.start(window: UIWindow(frame: UIScreen.main.bounds))
        
        return true
    }
}

