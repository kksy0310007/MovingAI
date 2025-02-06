//
//  EventNotificationListCell.swift
//  MovingAI
//
//  Created by soyoung on 2/3/25.
//

import UIKit
import SnapKit

class EventNotificationListCell: UITableViewCell {
    
    static let identifier = "EventNotificationListCell"
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "date"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let eventLabel: UILabel = {
        let label = UILabel()
        label.text = "Event"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(title)
        contentView.addSubview(dateLabel)
        contentView.addSubview(eventLabel)
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(97)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(15)
//            make.trailing.equalTo(eventLabel.snp.leading).offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
//            make.trailing.equalTo(eventLabel.snp.leading).offset(-10)
        }
        
        eventLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
