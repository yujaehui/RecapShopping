//
//  ProfileViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var nicknameStateLabel: UILabel!
    @IBOutlet var completeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        profileButton.setImage(UIImage(named: "profile1"), for: .normal)
        profileButton.setTitle("", for: .normal)
        profileButton.layer.cornerRadius = profileButton.bounds.width / 2
        profileButton.clipsToBounds = true
        profileButton.layer.borderWidth = 4
        profileButton.layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
    
    
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요 :)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nicknameTextField.textColor = .text
        nicknameTextField.borderStyle = .none
        nicknameTextField.underLine(viewSize: view.bounds.width, color: .text)
        
        nicknameStateLabel.text = "닉네임에는 @를 포함할 수 없습니다."
        nicknameStateLabel.textColor = .point
        nicknameStateLabel.font = .systemFont(ofSize: 14)
        
        completeButton.primaryButton("완료")
        
        
    }

}

extension UITextField {
    func underLine(viewSize: CGFloat, color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.height, width: viewSize-48, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
        
    }
}
