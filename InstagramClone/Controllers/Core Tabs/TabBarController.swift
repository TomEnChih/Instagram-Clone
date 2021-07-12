//
//  TabBarController.swift
//  InstagramClone
//
//  Created by 董恩志 on 2021/6/25.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setTabBar()
    }
    
    // MARK: - Methods
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let vc = PhotoSelectorController()
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    private func setTabBar() {
        
        let homeVC = HomeController()
        let navHomeVC = templateNavController(homeVC, unselectedImage: "house", selectedImage: "house.fill")
        
        let userSearchVC = UserSearchController()
        let navUserSearchVC = templateNavController(userSearchVC, unselectedImage: "magnifyingglass", selectedImage: "magnifyingglass")
        
        let photoSelectorVC = PhotoSelectorController()
        let navProduceVC = templateNavController(photoSelectorVC, unselectedImage: "plus.square", selectedImage: "plus.square.fill")
        
        let notificationsVC = NotificationsVC()
        let navNotificationsVC = templateNavController(notificationsVC, unselectedImage: "bell", selectedImage: "bell.fill")
        
        let profileVC = UserProfileController()
        let navProfileVC = templateNavController(profileVC, unselectedImage: "person", selectedImage: "person.fill")
        
        
        self.viewControllers = [navHomeVC,navUserSearchVC,navProduceVC,navNotificationsVC,navProfileVC]
    }
    
    
    
    private func templateNavController(_ viewController: UIViewController,
                                       unselectedImage: String,
                                       selectedImage: String)-> UINavigationController {
        
        let nav = UINavigationController(rootViewController: viewController)
        
        nav.tabBarItem.image = UIImage(systemName: unselectedImage)
        nav.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
        
        return nav
    }
    
}
