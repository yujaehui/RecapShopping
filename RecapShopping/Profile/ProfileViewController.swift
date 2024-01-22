//
//  ProfileViewController.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 1/19/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var cameraImageView: UIImageView!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var nicknameStateLabel: UILabel!
    @IBOutlet var completeButton: UIButton!
    
    var accessType: AccessType = .setting
    var userNickname = ""
    var profileImage = Int.random(in: 1...4)
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        configureUI()
        
        profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let profileImage = UserDefaultsManager.shared.profileImage
        profileButton.setImage(UIImage(named: "profile\(profileImage)"), for: .normal)
        profileButton.setTitle("", for: .normal)
    }
    
    
    @IBAction func textFieldState(_ sender: UITextField) {
        guard let text = sender.text else { return }
        if text.isEmpty {
            completeButton.isEnabled = false
        }
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let forbiddenCharacters = ["@", "#", "$", "%"]
        let forbiddenNumbers = ["0","1","2","3","4","5","6","7","8","9"]
        if text.count < 2 || text.count > 10 {
            stateTextField("닉네임은 2글자 이상, 10글자 이내만 가능합니다.", color: .systemRed, isEnabled: false)
        } else if forbiddenCharacters.contains(where: { text.contains($0) }) {
            stateTextField("닉네임에 @, #, $, %를 입력할 수 없습니다.", color: .systemRed, isEnabled: false)
        } else if forbiddenNumbers.contains(where: { text.contains($0) }) {
            stateTextField("닉네임에 숫자는 입력할 수 없습니다.", color: .systemRed, isEnabled: false)
        } else {
            stateTextField("사용가능한 닉네임입니다.", color: .point, isEnabled: true)
        }
    }
    
    func stateTextField(_ text: String, color: UIColor, isEnabled: Bool) {
        nicknameStateLabel.text = text
        nicknameStateLabel.textColor = color
        completeButton.isEnabled = isEnabled
    }
    
    @objc func profileButtonClicked() {
        let sb = UIStoryboard(name: "Profile", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileImageViewController.identifier) as! ProfileImageViewController
        vc.type = accessType // setting or edit
        vc.userSelect = UserDefaultsManager.shared.profileImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func cancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonClicked() {
        guard let text = nicknameTextField.text else { return }
        userNickname = text
        UserDefaultsManager.shared.nickname = userNickname // get?
        
        if accessType == .setting { // 기존의 온보딩 화면과 프로필 '설정' 화면을 메모리에서 지움
            UserDefaults.standard.setValue(true, forKey: "UserState")
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let sb = UIStoryboard(name: "Search", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
            vc.tabBar.backgroundColor = .background
            vc.tabBar.tintColor = .point
            vc.tabBar.barTintColor = .secondaryLabel
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        } else { // setting이 아니고 edit인 경우에는 화면을 새로 그릴 필요는 없음
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: setNavigation
extension ProfileViewController {
    func setNavigation() {
        navigationItem.title = accessType == .setting ? "프로필 설정" : "프로필 수정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        navigationItem.backBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
}

// MARK: configureUI
extension ProfileViewController {
    func configureUI() {
        setViewBackgroundColor()
        cameraImageView.image = UIImage(named: "camera")
        
        if UserDefaultsManager.shared.profileImage == 0 {
            UserDefaultsManager.shared.profileImage = profileImage
        }
        
        profileButton.setTitle("", for: .normal)
        profileButton.configureProfileButton()
    
        nicknameTextField.becomeFirstResponder()
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요 :)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nicknameTextField.textColor = .text
        nicknameTextField.borderStyle = .none
        nicknameTextField.underLine(viewSize: view.bounds.width, color: .text)
        nicknameTextField.text = accessType == .setting ? "" : UserDefaultsManager.shared.nickname // set?
        
        nicknameStateLabel.text = ""
        nicknameStateLabel.font = FontStyle.tertiary
        
        completeButton.greenButton("완료")
    }
}
