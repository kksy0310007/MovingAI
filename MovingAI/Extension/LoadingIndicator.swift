//
//  LoadingIndicator.swift
//  MovingAI
//
//  Created by soyoung on 12/20/24.
//


import UIKit

class LoadingIndicator: UIView {
    
    let loader = UIActivityIndicatorView(style: .large)
    
    static let shared: LoadingIndicator = {
        let instance = LoadingIndicator()
        return instance
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepared()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepared() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Set frame to cover the entire screen
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            self.frame = keyWindow.frame
        }
                
        // Configure loader
        loader.color = .white
        loader.center = self.center
        self.addSubview(loader)
    }
    
    func show() {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            print("Error: Could not find the key window")
            return
        }
                
        keyWindow.addSubview(self)
        loader.startAnimating()
    }
    
    func hide() {
        loader.stopAnimating()
        self.removeFromSuperview()
    }
}
