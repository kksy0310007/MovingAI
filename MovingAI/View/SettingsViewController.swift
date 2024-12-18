//
//  SettingsViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/5/24.
//

import UIKit

class SettingsViewController: UIViewController {

    var customTabBar = CustomTabBar()
//    var customTabBarVC = CustomTabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상단 타이틀 바
        addNavigationBar(titleString: "SettingsViewController",isBackButtonVisible: true)
        navigationController?.navigationBar.tintColor = UIColor.white
        
//        customTabBar.didTapButton = { [unowned self] in
//            self.navigationController?.popViewController(animated: true)
//            self.customTabBarVC.selectedIndex = 1
//        }
        

    }


}
