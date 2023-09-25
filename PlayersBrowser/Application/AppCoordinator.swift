//
//  AppCoordinator.swift
//  PlayersBrowser
//
//  Created by mukov on 19.09.23.
//

import UIKit

class AppCoordinator {
    private lazy var tabBarController:UITabBarController = {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [playerListNavigationController, aboutViewController]
        
        return tabBar
    }()
    
    private lazy var playerListNavigationController: UINavigationController = {
        let playerList = UINavigationController()
        playerList.tabBarItem.title = "Home"
        
        return playerList
    }()
    
    private lazy var aboutViewController: AboutViewController = {
        let about = AboutViewController(viewModel: AboutViewModel())
        about.tabBarItem.title = "About"
        
        return about
    }()
    
    private lazy var playerListCoordinator: PlayerListCoordinator = {
        return PlayerListCoordinator(navigationController: playerListNavigationController)
    }()
    
    var window: UIWindow?
    
    func start(window: UIWindow) {
        self.window = window
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        playerListCoordinator.start()
    }
}
