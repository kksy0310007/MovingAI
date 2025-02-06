//
//  EventFilterPopupViewController.swift
//  MovingAI
//
//  Created by soyoung on 2/6/25.
//

import UIKit
import SnapKit

protocol EventFilterPopupDelegate: AnyObject {
    func popupDidSelectButton()

}

class EventFilterPopupViewController: UIViewController {
    
    // 장비 리스트
//    private let deviceListData: [AssetData]
    // 이벤트 리스트
//    private let eventListData: [AssetData] // 수정 필요
    // 날짜 데이터
//    private let selectedDate: String
    
    // 델리게이트 선언
    weak var delegate: EventFilterPopupDelegate?
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "조회"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .black
        return label
    }()
    
    private let dateFilterButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage(systemName: "calendar", withConfiguration: imageConfig)
        var config = UIButton.Configuration.tinted()
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.backgroundColor = .lightGray
        button.setTitle("2025-02-05", for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(dateFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let deviceLabel: UILabel = {
        let label = UILabel()
        label.text = "장비"
        label.textColor = .black
        return label
    }()
    
    private let deviceFilterButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .trailing
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.backgroundColor = .white
        button.setTitle("선택", for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(deviceFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let eventLabel: UILabel = {
        let label = UILabel()
        label.text = "이벤트"
        label.textColor = .black
        return label
    }()
    
    private let eventFilterButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .trailing
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.backgroundColor = .white
        button.setTitle("선택", for: .normal)
        button.setImage(image, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(eventFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.tintColor = .gray
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("적용", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.tintColor = UIColor(cgColor: CGColor(red: 50/255, green: 83/255, blue: 213/255, alpha: 1.0))
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraint()
        
        
    }
    
    func setConstraint() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.dateFilterButton)
        self.contentView.addSubview(self.deviceLabel)
        self.contentView.addSubview(self.deviceFilterButton)
        self.contentView.addSubview(self.eventLabel)
        self.contentView.addSubview(self.eventFilterButton)
        
        self.contentView.addSubview(self.closeButton)
        self.contentView.addSubview(self.okButton)
        
        
        self.contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(400)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.dateFilterButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        self.deviceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateFilterButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.deviceFilterButton.snp.makeConstraints { make in
            make.top.equalTo(deviceLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        self.eventLabel.snp.makeConstraints { make in
            make.top.equalTo(deviceFilterButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.eventFilterButton.snp.makeConstraints { make in
            make.top.equalTo(eventLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(90)
            make.leading.equalToSuperview().offset(40)
        }
        
        self.okButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(90)
            make.trailing.equalToSuperview().offset(-40)
        }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func okButtonTapped() {
        print("okButtonTapped")
    }
    
    @objc private func dateFilterButtonTapped() {
        print("dateFilterButtonTapped")
    }
    
    @objc private func deviceFilterButtonTapped() {
        print("deviceFilterButtonTapped")
    }
    
    @objc private func eventFilterButtonTapped() {
        print("eventFilterButtonTapped")
    }
}
