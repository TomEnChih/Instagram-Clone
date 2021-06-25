//
//  TabBarController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    

    func setTabBar() {
        let homeVC = HomeVC()
        let navHomeVC = UINavigationController(rootViewController: homeVC)
        
        let exploreVC = ExploreVC()
        let navExploreVC = UINavigationController(rootViewController: exploreVC)
        
        let cameraVC = CameraVC()
        let navProduceVC = UINavigationController(rootViewController: cameraVC)
        
        let notificationsVC = NotificationsVC()
        let navNotificationsVC = UINavigationController(rootViewController: notificationsVC)
        
        let profileVC = ProfileVC()
        let navProfileVC = UINavigationController(rootViewController: profileVC)
        
        navHomeVC.tabBarItem.image = UIImage(systemName: "house")
        
        navExploreVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
                
        navProduceVC.tabBarItem.image = UIImage(systemName: "plus.square")
        
        navNotificationsVC.tabBarItem.image = UIImage(systemName:"bell")
        
        navProfileVC.tabBarItem.image = UIImage(systemName: "person")
        
        self.viewControllers = [navHomeVC,navExploreVC,navProduceVC,navNotificationsVC,navProfileVC]
    }

}
