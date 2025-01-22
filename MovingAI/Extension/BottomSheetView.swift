//
//  BottomSheetView.swift
//  MovingAI
//
//  Created by soyoung on 1/17/25.
//

import UIKit
import SnapKit

class BottomSheetView: UIView {
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(cgColor: CGColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0))
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupViewHierarchy()
        setupViewAttributes()
        setupLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupViewHierarchy(){
        self.addSubview(lineView)
    }
        
    func setupViewAttributes(){
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 28
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 왼쪽 위, 오른쪽 위 모서리만 둥글게
        self.clipsToBounds = true
    }
        
    func setupLayout(){
        lineView.layer.cornerRadius = 5
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
        }
    }
}
