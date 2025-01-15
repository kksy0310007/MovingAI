//
//  MicPopupViewController.swift
//  MovingAI
//
//  Created by soyoung on 1/9/25.
//

import UIKit
import SnapKit

protocol MicPopupDelegate: AnyObject {
    func micButtonTouchDown()
    func micButtonTouchUpInside()
}

class MicPopupViewController: UIViewController {
    
    // 델리게이트 선언
    weak var delegate: MicPopupDelegate?
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.3254901961, blue: 0.8352941176, alpha: 1)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이크 버튼을 누른 채 말해주세요."
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let micButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "microphone.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.2528479099, green: 0.4240060449, blue: 0.8678660989, alpha: 1)
        button.backgroundColor = .white
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 10
        button.layer.borderColor = #colorLiteral(red: 0.2528479099, green: 0.4240060449, blue: 0.8678660989, alpha: 1)
        button.addTarget(self, action: #selector(micButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(micButtonTouchUpInside), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setConstraint()
        
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func micButtonTouchDown() {
        print("micButtonTouchDown")
        titleLabel.text = "듣고 있습니다."
        
        delegate?.micButtonTouchDown()
    }
    
    @objc private func micButtonTouchUpInside() {
        print("micButtonTouchUpInside")
        titleLabel.text = "마이크 버튼을 누른 채 말해주세요."
        
        delegate?.micButtonTouchUpInside()
    }
    
    private func setConstraint() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.closeButton)
        self.contentView.addSubview(self.micButton)
        
        self.contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        self.micButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.height.width.equalTo(80)
        }
        
    }
    
}
