//
//  PushSettingsViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/24/24.
//

import UIKit
import SwiftyToaster

class PushSettingsViewController: UIViewController {
    
    let isPushSetting = UserDefaults.standard.bool(forKey: "isPushSetting")
    
    private let pushLabel: UILabel = {
        let label = UILabel()
        label.text = "푸시 전체"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        푸시 메시지가 오지 않을 경우
        스마트폰 설정 > 알림에서 알림설정을 확인해주세요.
        """
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
        
    private let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        let isAutoLogin = UserDefaults.standard.bool(forKey: "isAutoLogin")
        if (isAutoLogin) {
            // 자동 로그인 에만 푸시 알림 설정 켜기 가능.
            toggle.isEnabled = true
        } else {
            UserDefaults.standard.set(false, forKey: "isPushSetting")
            Toaster.shared.makeToast("자동 로그인이 아니면 푸시 알림을 설정 할 수 없습니다.", .middle)
            toggle.isEnabled = false
        }
    
        toggle.onTintColor = UIColor(_colorLiteralRed: 50/255, green: 83/255, blue: 213/255, alpha: 1.0) // 활성화 상태 배경 색상
        toggle.addTarget(self, action: #selector(onClickSwitch(sender:)), for: .valueChanged)
        return toggle
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray // 구분선 색상
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상단 타이틀 바
        addNavigationBar(titleString: "푸쉬 알림 설정",isBackButtonVisible: true)
        
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(pushLabel)
        view.addSubview(toggleSwitch)
        view.addSubview(descriptionLabel)
        view.addSubview(separator)
        
        pushLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        toggleSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(pushLabel)
        }
        
        if (self.isPushSetting) {
            toggleSwitch.isOn = true
        } else {
            toggleSwitch.isOn = false
        }
                
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(pushLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(0.7)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
        }
        
    }
    
    @objc func onClickSwitch(sender: UISwitch) {

        print("sender.isOn ==== > sender.isOn : \(sender.isOn)")
        UserDefaults.standard.set(sender.isOn, forKey: "isPushSetting")
        Toaster.shared.makeToast("푸시 알림 설정이 완료되었습니다.", .short)
        
        if (sender.isOn) {
            print("푸쉬 알림 받기 시작!")
            eventService.shared.start()
        }
    }


}
