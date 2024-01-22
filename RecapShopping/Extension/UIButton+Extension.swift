//
//  UIButton+Extension.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/21/24.
//

import UIKit

extension UIButton {
    func greenButton(_ title: String) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = FontStyle.primary
        self.backgroundColor = .point
        self.tintColor = .text
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func configureProfileButton() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 4
        self.layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
    }
}
