//
//  CamListCell.swift
//  MovingAI
//
//  Created by soyoung on 12/24/24.
//

import UIKit
import SnapKit

enum CamListCellHeight: CGFloat {
    case expanded = 97
    case simple = 78
}


class CamListCell: UITableViewCell {
    
    static let identifier = "CamListCell"
    private var currentHeight: CamListCellHeight = .expanded
    
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
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let aiModelLabel: UILabel = {
        let label = UILabel()
        label.text = "AI 모델: "
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
        contentView.addSubview(aiModelLabel)
        
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
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(imageBtn.snp.leading).offset(-10)
        }
        
        aiModelLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(imageBtn.snp.leading).offset(-10)
        }
        
        imageBtn.snp.makeConstraints { make in
            make.centerY.equalTo(title.snp.centerY)
            make.height.width.equalTo(26)
            make.trailing.equalToSuperview().offset(-15)
            
        }
    }
    
    // 높이를 업데이트하는 메서드
        func updateCellHeight(to height: CamListCellHeight) {
            self.currentHeight = height
            
            // 높이에 따라 레이아웃 변경
            switch height {
            case .expanded:
                title.isHidden = false
                dateLabel.isHidden = false
                aiModelLabel.isHidden = false
            case .simple:
                title.snp.makeConstraints { make in
                    make.centerY.equalToSuperview().offset(-5)
                }
                title.isHidden = false
                dateLabel.isHidden = true
                aiModelLabel.isHidden = true
            }
            
            // 강제로 레이아웃 갱신
            setNeedsLayout()
            layoutIfNeeded()
        }
}
