//
//  CustomSwitch.swift
//  MovingAI
//
//  Created by soyoung on 12/30/24.
//

import UIKit
import SnapKit


final class CustomSwitch: UIControl {
    private enum Constant {
        static let duration = 0.25
    }
    
    private let barView: RoundableView = {
        let view = RoundableView()
        view.backgroundColor = .gray
        return view
    }()
    
    private let circleView: RoundableView = {
        let view = RoundableView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        return view
    }()
        
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "Ch1" // 초기 상태
        return label
    }()
    
    
    var isOn = false {
        didSet {
            self.sendActions(for: .touchUpInside)
            
            UIView.animate(
                withDuration: Constant.duration,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.barView.backgroundColor = self.isOn ? self.barTintColor : self.barColor
                    
                    self.circleView.snp.remakeConstraints { make in
                        if self.isOn {
                            make.right.equalTo(self.barView.snp.right)
                            make.top.bottom.equalToSuperview()
                            make.width.equalTo(self.barView.snp.height)
                        } else {
                            make.left.equalTo(self.barView.snp.left)
                            make.top.bottom.equalToSuperview()
                            make.width.equalTo(self.barView.snp.height)
                        }
                    }
                    
                    // 라벨 텍스트 업데이트
                    self.label.text = self.isOn ? "Ch2" : "Ch1"
                    
                    self.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    var barColor = UIColor.gray {
        didSet { self.barView.backgroundColor = self.barColor }
    }
    
    var barTintColor = UIColor.lightGray
    var circleColor = UIColor.white {
        didSet { self.circleView.backgroundColor = self.circleColor }
    }
        
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("xib is not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.barView)
        self.barView.addSubview(self.circleView)
        self.barView.addSubview(self.label)
        
        self.barView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        self.circleView.snp.makeConstraints { make in
            make.left.equalTo(self.barView.snp.left)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(self.barView.snp.height)
        }
        
        self.label.snp.makeConstraints { make in
            make.center.equalTo(circleView)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isOn = !self.isOn
    }
    
}

final class RoundableView: UIView {
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
