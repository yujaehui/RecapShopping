//
//  PointColorButton.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/29/24.
//

import UIKit

class PointColorButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        titleLabel?.font = FontStyle.primary
        backgroundColor = .point
        tintColor = .text
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
