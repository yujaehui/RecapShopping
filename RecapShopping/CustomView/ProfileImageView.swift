//
//  ProfileImageView.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/29/24.
//

import UIKit

class ProfileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = bounds.width / 2
        }
    
    func configureView() {
        clipsToBounds = true
//        DispatchQueue.main.async {
//            self.layer.cornerRadius = self.bounds.width/2
//        }
        layer.borderWidth = 4
        layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
        isUserInteractionEnabled = true
    }
}
