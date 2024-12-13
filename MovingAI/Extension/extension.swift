//
//  extension.swift
//  MovingAI
//
//  Created by soyoung on 12/6/24.
//

import UIKit
import SnapKit

extension UIViewController {
    
    // Custom Navigation Bar
    func addNavigationBar(titleString: String, isBackButtonVisible: Bool) {
        // TopBar
        let customView = UIView()
        
        customView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 20)
            make.height.equalTo(44)
        }
        
        // Button (optional)
        if isBackButtonVisible {
            // 뒤로가기 버튼
            let backButton = UIButton(type: .system)
            backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            backButton.tintColor = .white
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            customView.addSubview(backButton)
                    
            backButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(-10)
                make.width.height.equalTo(44)
            }
            
        } else {
            // 설정 버튼
            let settingsButton = UIButton(type: .system)
            settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
            settingsButton.tintColor = .white
            settingsButton.translatesAutoresizingMaskIntoConstraints = false
            settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
            customView.addSubview(settingsButton)
            
            settingsButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(10)
                make.width.height.equalTo(44)
            }
        }
        
        // 타이틀
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = titleString
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Navigation 설정 변경
        self.navigationItem.titleView = customView
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2528479099, green: 0.4240060449, blue: 0.8678660989, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false // 투명도 해제
        changeStatusBarBgColor(bgColor: #colorLiteral(red: 0.2528479099, green: 0.4240060449, blue: 0.8678660989, alpha: 1))
        
        // Ensure Status Bar text is white
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // SettingButton Action
    @objc private func settingsButtonTapped() {
            print("Settings button tapped!")
            let createAdNavController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController
            createAdNavController.modalPresentationCapturesStatusBarAppearance = true
            self.present(createAdNavController, animated: true, completion: nil)
    }
    
    // BackButton Action
    @objc private func backButtonTapped() {
            self.navigationController?.popViewController(animated: true)
    }

    // StatusBar 배경 컬러 변경
    func changeStatusBarBgColor(bgColor: UIColor?) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            let statusBarManager = window?.windowScene?.statusBarManager
            
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0.0))
            statusBarView.backgroundColor = bgColor
            
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = bgColor
        }
    }
}
