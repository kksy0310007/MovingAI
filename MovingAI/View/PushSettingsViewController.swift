//
//  PushSettingsViewController.swift
//  MovingAI
//
//  Created by soyoung on 12/24/24.
//

import UIKit

class PushSettingsViewController: UIViewController {
    
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
        toggle.isOn = true
        toggle.onTintColor = UIColor(_colorLiteralRed: 50/255, green: 83/255, blue: 213/255, alpha: 1.0) // 활성화 상태 배경 색상
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


}
