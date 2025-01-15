//
//  PopupViewController.swift
//  MovingAI
//
//  Created by soyoung on 1/7/25.
//

import UIKit
import SnapKit

protocol PopupDelegate: AnyObject {
    func popupDidSelectItem(index: Int)
}

class PopupViewController: UIViewController {

    private let items: [PresetData]
    
    // 델리게이트 선언
    weak var delegate: PopupDelegate?
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "안내방송"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(VoiceListCell.self, forCellReuseIdentifier: VoiceListCell.identifier)
        return tableView
    }()
    
    
    init(items: [PresetData]) {
            self.items = items
            super.init(nibName: nil, bundle: nil)
            modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraint()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func setConstraint() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.closeButton)
        
        self.contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(320)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(self.tableView)
        self.tableView.backgroundColor = .white
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
}
extension PopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceListCell", for: indexPath) as! VoiceListCell
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.fileName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 선택 시 처리할 로직 추가
        delegate?.popupDidSelectItem(index: indexPath.row)
        dismiss(animated: true)
    }
}
