//
//  CustomTabBarController.swift
//  MovingAI
//
//  Created by soyoung on 12/5/24.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabBar.isTranslucent = false
        tabBar.tintColor = #colorLiteral(red: 0.2528479099, green: 0.4240060449, blue: 0.8678660989, alpha: 1)
        
        delegate = self
        
        // Instantiate view controllers
        let mainNav = self.storyboard?.instantiateViewController(withIdentifier: "MainNav") as! UINavigationController
        
        let eventNotificationNav = self.storyboard?.instantiateViewController(withIdentifier: "EventNotificationNav") as! UINavigationController
        
        let camListNav = self.storyboard?.instantiateViewController(withIdentifier: "CamListNav") as! UINavigationController
        
        let settingsNav = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController
        
        
        // Create TabBar items
        eventNotificationNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell.fill"), selectedImage: UIImage(systemName: "bell.fill"))
        
        camListNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "text.document"), selectedImage: UIImage(systemName: "text.document"))
        
        mainNav.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        
        
        // Assign viewControllers to tabBarController
        let viewControllers = [eventNotificationNav, mainNav, camListNav]
        self.setViewControllers(viewControllers, animated: false)
        
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapButton = { [unowned self] in
            self.routeToCreateNewAd()
        }
        
    }
    
    func routeToCreateNewAd() {
//        let createAdNavController = self.storyboard?.instantiateViewController(withIdentifier: "MainNav") as! UINavigationController
//        createAdNavController.modalPresentationCapturesStatusBarAppearance = true
//        self.present(createAdNavController, animated: true, completion: nil)
//
        self.selectedIndex = 1
    }

}

// MARK: - UITabBarController Delegate
extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        // Your middle tab bar item index.
        if selectedIndex == 1 {
            return false
        }
        
        return true
    }
}
