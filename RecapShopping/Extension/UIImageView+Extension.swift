//
//  UIImageView+Extension.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/21/24.
//

import UIKit

extension UIImageView {
    func configureProfileImageView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 4
        self.layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
    }
}
