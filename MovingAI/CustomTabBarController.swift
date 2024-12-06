//
//  CustomTabBarController.swift
//  MovingAI
//
//  Created by soyoung on 12/5/24.
// 하단 탭바

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.tintColor = #colorLiteral(red: 0.2528479099, green: 0.4240060449, blue: 0.8678660989, alpha: 1)
        
        delegate = self
        
        // 네비게이션 이름 설정
        let mainNav = self.storyboard?.instantiateViewController(withIdentifier: "MainNav") as! UINavigationController
        
        let eventNotificationNav = self.storyboard?.instantiateViewController(withIdentifier: "EventNotificationNav") as! UINavigationController
        
        let camListNav = self.storyboard?.instantiateViewController(withIdentifier: "CamListNav") as! UINavigationController
        
        let settingsNav = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController
        
        
        // 탭바 아이템
        eventNotificationNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell.fill"), selectedImage: UIImage(systemName: "bell.fill"))
        
        camListNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "text.document"), selectedImage: UIImage(systemName: "text.document"))
        
        mainNav.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        
        
        // 탭 바 셋팀
        let viewControllers = [eventNotificationNav, mainNav, camListNav]
        self.setViewControllers(viewControllers, animated: false)
        
        // 가운데 버튼 세팅
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        // 클릭 리스너
        tabBar.didTapButton = { [unowned self] in
            self.routeToCreateNewAd()
        }
        
        
        // 시작 탭바 페이지
        self.selectedIndex = 1
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
