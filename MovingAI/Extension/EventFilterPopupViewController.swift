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
    
    let pickerView = UIPickerView()
    let pickerToolbar = UIToolbar()
    
    let datePickerView = UIDatePicker()
    
    var selectedPickerType: Int = 0  // 1: 첫 번째 피커, 2: 두 번째 피커
    let firstPickerData = ["Apple", "Banana", "Cherry", "Date"]
    let secondPickerData = ["Red", "Green", "Blue", "Yellow"]
    
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
        button.backgroundColor = UIColor(_colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
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
        button.backgroundColor = UIColor(_colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
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
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        pickerView.isHidden = true
        pickerView.backgroundColor = .white
        
        // Toolbar 설정
        pickerToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissPicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        pickerToolbar.setItems([flexSpace, doneButton], animated: false)
        pickerToolbar.isHidden = true
        
        view.addSubview(pickerToolbar)
        
        pickerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
                
        pickerToolbar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pickerView.snp.top)
            make.height.equalTo(50)
        }
        
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.locale = Locale(identifier: "ko-KR")
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePickerView)
        datePickerView.isHidden = true
        datePickerView.backgroundColor = .white
        datePickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        datePickerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(400)
        }
        
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func okButtonTapped() {
        print("okButtonTapped")
        
        delegate?.popupDidSelectButton()
    }
    
    @objc private func dateFilterButtonTapped() {
        print("dateFilterButtonTapped")
        showDatePicker()
    }
    
    @objc private func deviceFilterButtonTapped() {
        print("deviceFilterButtonTapped")
        selectedPickerType = 1
        pickerView.reloadAllComponents()
        showPicker()
    }
    
    @objc private func eventFilterButtonTapped() {
        print("eventFilterButtonTapped")
        selectedPickerType = 2
        pickerView.reloadAllComponents()
        showPicker()
    }
    
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        dateFilterButton.setTitle(dateFormat(date: sender.date), for: .normal)
        datePickerView.isHidden = true
    }

    // PickerView 표시 (애니메이션 효과)
    func showPicker() {
        pickerView.isHidden = false
        pickerToolbar.isHidden = false
        pickerView.transform = CGAffineTransform(translationX: 0, y: pickerView.frame.height)
        pickerToolbar.transform = CGAffineTransform(translationX: 0, y: pickerToolbar.frame.height)
            
        self.pickerView.transform = .identity
        self.pickerToolbar.transform = .identity
    }
    
    func showDatePicker() {
        datePickerView.isHidden = false
        datePickerView.transform = CGAffineTransform(translationX: 0, y: pickerView.frame.height)
        self.datePickerView.transform = .identity
    }
        // PickerView 숨김
    @objc func dismissPicker() {
        self.pickerView.isHidden = true
        self.pickerToolbar.isHidden = true
    }
    
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
}
extension EventFilterPopupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if selectedPickerType == 1 {
            return firstPickerData[row]
        } else {
            return secondPickerData[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedPickerType == 1 {
            return firstPickerData.count
        } else {
            return secondPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = selectedPickerType == 1 ? firstPickerData[row] : secondPickerData[row]
        
        if selectedPickerType == 1 {
            deviceFilterButton.setTitle(selectedValue, for: .normal)
        } else {
            eventFilterButton.setTitle(selectedValue, for: .normal)
        }
    }
    
}
