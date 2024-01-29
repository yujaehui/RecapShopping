//
//  UITextField+Extension.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/21/24.
//

import UIKit

extension UITextField {
    func underLine(viewSize: CGFloat, color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: 42, width: viewSize-48, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
    }
}
