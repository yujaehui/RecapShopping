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
}
