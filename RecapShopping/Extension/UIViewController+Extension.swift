//
//  UIViewController+Extension.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/21/24.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    
    func setViewBackgroundColor() {
        self.view.backgroundColor = .background
    }
}
