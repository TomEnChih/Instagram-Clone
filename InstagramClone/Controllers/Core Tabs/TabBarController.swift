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
        
        navHomeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        
        navExploreVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
                
        navProduceVC.tabBarItem.image = UIImage(systemName: "plus.square.fill")
        
        navNotificationsVC.tabBarItem.image = UIImage(systemName:"bell.fill")
        
        navProfileVC.tabBarItem.image = UIImage(systemName: "person.fill")
        
        self.viewControllers = [navHomeVC,navExploreVC,navNotificationsVC,navProduceVC,navProfileVC]
    }

}
