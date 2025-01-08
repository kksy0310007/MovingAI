//
//  VoiceListCell.swift
//  MovingAI
//
//  Created by soyoung on 1/7/25.
//

import UIKit
import SnapKit

class VoiceListCell: UITableViewCell {
    static let identifier = "VoiceListCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let image: UIImageView = {
        let imageBtn = UIImageView()
        imageBtn.image = UIImage(systemName: "microphone.fill")
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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(image)
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(61)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(image.snp.leading).offset(-10)
        }
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(26)
            make.trailing.equalToSuperview().offset(-15)
            
        }
    }
}
