//
//  ProfileViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func willDismiss()
}

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var cameraImageView: UIImageView!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var nicknameStateLabel: UILabel!
    @IBOutlet var completeButton: UIButton!
    
    var accessType: AccessType = .setting
    var userNickname = ""
    
    weak var delegate: ProfileViewControllerDelegate?
    var tableView: UITableView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        cameraImageView.image = UIImage(named: "camera")
        
        let profileImage = UserDefaultsManager.shared.profileImage
        profileButton.setImage(UIImage(named: "profile\(profileImage+1)"), for: .normal)
        profileButton.setTitle("", for: .normal)
        
        profileButton.layer.cornerRadius = profileButton.bounds.width / 2
        profileButton.clipsToBounds = true
        profileButton.layer.borderWidth = 4
        profileButton.layer.borderColor = CGColor(srgbRed: 73/255, green: 220/255, blue: 146/255, alpha: 1)
    
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요 :)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nicknameTextField.textColor = .text
        nicknameTextField.borderStyle = .none
        nicknameTextField.underLine(viewSize: view.bounds.width, color: .text)
        nicknameTextField.text = accessType == .setting ? "" : UserDefaultsManager.shared.nickname
        
        nicknameStateLabel.text = ""
        nicknameStateLabel.font = .systemFont(ofSize: 14)
        
        completeButton.primaryButton("완료")
        completeButton.isEnabled = true
        
        profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
        
        setNavigation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let profileImage = UserDefaultsManager.shared.profileImage
        profileButton.setImage(UIImage(named: "profile\(profileImage+1)"), for: .normal)
        profileButton.setTitle("", for: .normal)
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let forbiddenCharacters = ["@", "#", "$", "%"]
        let forbiddenNumbers = ["0","1","2","3","4","5","6","7","8","9"]
        if text.count < 2 || text.count > 10 {
            nicknameStateLabel.text = "닉네임은 2글자 이상, 10글자 이내만 가능합니다."
            nicknameStateLabel.textColor = .systemRed
            completeButton.isEnabled = false
        } else if forbiddenCharacters.contains(where: { text.contains($0) }) {
            nicknameStateLabel.text = "닉네임에 @, #, $, %를 입력할 수 없습니다."
            nicknameStateLabel.textColor = .systemRed
            completeButton.isEnabled = false
        } else if forbiddenNumbers.contains(where: { text.contains($0) }) {
            nicknameStateLabel.text = "닉네임에 숫자는 입력할 수 없습니다."
            nicknameStateLabel.textColor = .systemRed
            completeButton.isEnabled = false
        } else {
            nicknameStateLabel.text = "사용가능한 닉네임입니다."
            nicknameStateLabel.textColor = .point
            completeButton.isEnabled = true
        }
    }
    
    func setNavigation() {
        navigationItem.title = accessType == .setting ? "프로필 설정" : "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
    
    @objc func profileButtonClicked() {
        let sb = UIStoryboard(name: "Profile", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ProfileImageViewController") as! ProfileImageViewController
        vc.type = accessType
        vc.userSelect = UserDefaultsManager.shared.profileImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func cancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonClicked() {
        guard let text = nicknameTextField.text else { return }
        userNickname = text
        UserDefaultsManager.shared.nickname = userNickname
        
        if accessType == .setting {
            
            UserDefaults.standard.setValue(true, forKey: "UserState")
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let sb = UIStoryboard(name: "Search", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        } else {
            delegate?.willDismiss()
            navigationController?.popViewController(animated: true)
        }
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
