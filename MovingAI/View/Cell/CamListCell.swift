//
//  CamListCell.swift
//  MovingAI
//
//  Created by soyoung on 12/24/24.
//

import UIKit
import SnapKit

class CamListCell: UITableViewCell {
    static let identifier = "CamListCell"
    
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
        return label
    }()
    
    let imageBtn: UIImageView = {
        let imageBtn = UIImageView()
        imageBtn.image = UIImage(systemName: "chevron.right")
        imageBtn.translatesAutoresizingMaskIntoConstraints = false
        imageBtn.tintColor = UIColor(displayP3Red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        imageBtn.contentMode = .scaleAspectFit
        return imageBtn
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
        contentView.addSubview(imageBtn)
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(97)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(imageBtn.snp.leading).offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(imageBtn.snp.leading).offset(-10)
        }
        
        imageBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(26)
            make.trailing.equalToSuperview().offset(-15)
            
        }
    }
}
