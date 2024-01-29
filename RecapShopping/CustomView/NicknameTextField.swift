//
//  NicknameTextField.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/29/24.
//

import UIKit

class NicknameTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        becomeFirstResponder()
        textColor = .text
        borderStyle = .none
    }
}
